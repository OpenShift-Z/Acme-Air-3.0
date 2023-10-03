/*******************************************************************************
* Copyright (c) 2013-2015 IBM Corp.
*
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
*    http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*******************************************************************************/

package com.acmeair.service;

import java.net.http.HttpResponse;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;
import java.util.List;

import javax.annotation.PostConstruct;
import javax.inject.Inject;
import javax.json.Json;
import javax.json.JsonReaderFactory;
import javax.ws.rs.Consumes;
import javax.ws.rs.FormParam;
import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.Response;
import javax.ws.rs.core.Response.Status;

import org.bson.Document;

import com.acmeair.mongo.ConnectionManager;
import com.acmeair.web.dto.CardInfo;
import com.mongodb.BasicDBObject;
import com.mongodb.client.FindIterable;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;

import javax.ws.rs.PathParam;

import org.eclipse.microprofile.openapi.annotations.Operation;
import org.eclipse.microprofile.openapi.annotations.enums.SchemaType;
import org.eclipse.microprofile.openapi.annotations.media.Content;
import org.eclipse.microprofile.openapi.annotations.media.Schema;
import org.eclipse.microprofile.openapi.annotations.parameters.Parameter;
import org.eclipse.microprofile.openapi.annotations.responses.APIResponse;

// import com.acmeair.mq.JmsPut;
import com.acmeair.mq.BasicProducer;

@Path("/cardService")
@Produces("application/json")
public class CardService{
  protected static final int DAYS_TO_ALLOW_SESSION = 1;
  private static final JsonReaderFactory factory = Json.createReaderFactory(null);

  private MongoCollection<Document> creditCardCollection;
  
//   private BasicProducer bp = new BasicProducer(BasicProducer.PRODUCER_PUT);

  @Inject 
  ConnectionManager connectionManager;
  
  @Inject 
  CardInfo cardInfo;
  
//   @Inject
//   JmsPut jmsPut;
  
  SimpleDateFormat sdf = new SimpleDateFormat("MM/yy");
  
  ArrayList<String> errorMessages = new ArrayList<String>();
    
	@GET
	@Path("/cardServiceHealthCheck")
	@Produces("application/json")
	public Response healthCheck() {
		return Response.ok("The API is up!").build();
	}
	
	@PostConstruct
	public void initialization() {
    MongoDatabase database = connectionManager.getDb();
    creditCardCollection = database.getCollection("CreditCardInfo");
  }
	
	@GET
	@Path("/getCreditCardInfo")
	@Produces("application/json")
	public Response getCardInfo() {
    FindIterable<Document> cardInfoDoc = creditCardCollection.find();
    return Response.ok(cardInfoDoc).build();
  }
	
	@GET
	@Path("/getCardByCardholder")
	@Consumes({ "application/x-www-form-urlencoded" })
	@Produces("application/json")
	public Response getCardByCardholder(@FormParam("cardholderName") String name) {
		BasicDBObject query = new BasicDBObject();
		String messageText = "Must provide Cardholder name";
		
		if(name!=null) {
			if(!name.isEmpty()) {
				
				query.put("Name", name);
				FindIterable<Document> cardInfoDoc = creditCardCollection.find(query);
				messageText = "Cardholder not found.";
				
				List<Document> cardList = new ArrayList();
				Iterator<Document> it = cardInfoDoc.iterator();
				if(it!=null && it.hasNext()) {
		    	while(it.hasNext()) {
		    		cardList.add(it.next());
		    	}
		    		return Response.ok(cardList).build();
		    }
			}
		}
  	return  Response
				.status(Status.BAD_REQUEST)
				.entity(messageText)
				.build();
  }
	
	@POST
	@Consumes({ "application/x-www-form-urlencoded" })
	@Path("/processCard")
	@Produces("application/json")
	public Response setCardInfo(@FormParam("cardholderName") String name,
			@FormParam("cardNumber") String cardNum,
			@FormParam("securityCode") String securityCode,
			@FormParam("expDate") String expDate,
			@FormParam("billingAddressLine1") String billingAddressLine1,
			@FormParam("billingAddressLine2") String billingAddressLine2,
			@FormParam("billingAddressCity") String billingAddressCity,
			@FormParam("billingAddressZipCode") String billingAddressZipCode,
			@FormParam("billingAddressStateProvince") String billingAddressStateProvince,
			@FormParam("billingAddressCountry") String billingAddressCountry,
			@FormParam("cost") String cost) throws ParseException {
		
		Response response = Response.status(Status.OK).build();
		 
		validateCardInfo(name, cardNum, securityCode, expDate);
		validateAddressInfo(billingAddressZipCode);
		//validateCardNumber(cardNum);
		
		if(errorMessages.isEmpty()) {
			cardInfo.setCardHolderName(name);
			cardInfo.setCardNumber(cardNum);
			cardInfo.setExpirationDate(sdf.parse(expDate));
			//cardInfo.setSecurityCode(securityCode);
			Document newCardInfo = new Document("Name", name)
					.append("Card Number", cardNum)
					//.append("Security_Code", securityCode)
					.append("Expiration Date", expDate)
					.append("Billing Address Line 1", billingAddressLine1)
					.append("Billing Address Line 2", billingAddressLine2)
					.append("Billing Address City", billingAddressCity)
					.append("Billing Address State/Province", billingAddressStateProvince)
					.append("Billing Address Country", billingAddressCountry)
					.append("Billing Address ZipCode", billingAddressZipCode)
					.append("Cost", cost);
			
			if(!checkCardExists(cardNum)) {
				creditCardCollection.insertOne(newCardInfo);
			}

			//This section is for putting to IBM MQ Queue
			
			// bp.send(newCardInfo.toString(), 1);
			
			// JmsPut.sendMessage(newCardInfo.toJson());
			// end MQ section

			response = Response.status(Status.OK).entity("Card Succecssfully Processed.").build();
		}
		else {
			response = Response.status(Status.BAD_REQUEST).entity(errorMessages).build();
		}
		
		return response;
	}
	
	public void validateCardInfo(String name, String cardNum, String securityCode, String expDate) {
		//CreditCardValidator validator = new CreditCardValidator();
  
    
    if(name!=null && cardNum!=null && securityCode != null && expDate != null) {
    	validateCardNumber(cardNum);
	    if(cardNum.isBlank() || securityCode.isBlank() || expDate.isBlank()) {
	    	errorMessages.add("Error: Card number, security code, and expiration date must be provided");
	    }
		  if(cardNum.length()!=16) {
		  	errorMessages.add("Error: The provided credit card number is invalid. Credit card number must be 16 digits. The number provided contains " + cardNum.length() + " digits.");
			}
		  if(!cardNum.matches("^[0-9]+$")) {
		  	errorMessages.add("Error: The provided credit card number is invalid. Credit Card number may only contain numeric characters.");
		  }
			if(securityCode.length()!=3 || !securityCode.matches("^[0-9]+$")) {
				errorMessages.add("Error: The provided security code is invalid. Security code must be 3 digits.");
			}
			if(expDate.length()!=5) {
//				response = Response
//						.status(Status.BAD_REQUEST)
//						.entity("The provided date is invalid. Please provide expiration date in MM/yy format.")
//						.build();
//				return response;
				errorMessages.add("Error: The provided date is invalid. Please provide expiration date in MM/yy format.");
			}
			else {
				Date parsedDate = new Date();
				try {
					parsedDate = sdf.parse(expDate);
				} catch (ParseException e) {
					e.printStackTrace();
				}
				if(parsedDate.before(new Date())) {
//					response = Response
//							.status(Status.BAD_REQUEST)
//							.entity("Error: Card is Expired.")
//							.build();
					errorMessages.add("Error: Card is Expired.");
				}
			}
    }
    else {
    	errorMessages.add("Error: Card number, security code, and expiration date must be provided.");
    }
		//return response;
	}
	
	public void validateAddressInfo(String zipCode) {
		if(zipCode!=null) {
			if(!zipCode.isBlank()) {
				if((zipCode.length()!=5 && zipCode.length()!=8)) {
					errorMessages.add("Error: Provided zip code is invalid. Zip Code must contain either 5 or 8 digits.");
				}
				if(!zipCode.matches("^[0-9]+$")) {
					errorMessages.add("Error: Provided zip code is invalid. Zip Code must only contain numeric characters.");
				}
			}
			else {
				errorMessages.add("Error: Must provide zip code.");
			}
		}
		else {
			errorMessages.add("Error: Must provide zip code.");
		}
	}
	
	public void validateCardNumber(String cardNum) { 
		String firstDigit = cardNum.substring(0, 1);
		if(!firstDigit.equals("7") && !firstDigit.equals("8") && !firstDigit.equals("9")) {
			errorMessages.add("Error: Invalid Credit Card Number. First digit of card number must be 7, 8, or 9.");
		}
	}
	
	public boolean checkCardExists(String cardNum) {
		BasicDBObject query = new BasicDBObject();
    query.put("Card_Number", cardNum);
		Document cardInfoDoc = creditCardCollection.find(query).first();
		if(cardInfoDoc==null ) {
    	return false;
    }
		return true;
	}
	
	
//  @ResponseStatus(HttpStatus.BAD_REQUEST)
//	public String throwResponseError() {
//		
//	}
	
	
	public void addCard() {
		
	}

	public String getRuntimeInfo() {
		// TODO Auto-generated method stub
		return null;
	}
  
}
