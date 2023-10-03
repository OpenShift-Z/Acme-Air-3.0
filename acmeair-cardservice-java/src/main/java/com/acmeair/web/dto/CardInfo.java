/*******************************************************************************
* Copyright (c) 2015 IBM Corp.
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

package com.acmeair.web.dto;

import java.io.Serializable;
import java.util.Date;

import javax.enterprise.context.ApplicationScoped;

//import javax.xml.bind.annotation.XmlAccessType;
//import javax.xml.bind.annotation.XmlAccessorType;
//import javax.xml.bind.annotation.XmlElement;
//import javax.xml.bind.annotation.XmlRootElement;
//
//@XmlAccessorType(XmlAccessType.PUBLIC_MEMBER)
//@XmlRootElement(name = "CardInfo")
@ApplicationScoped
public class CardInfo implements Serializable {

	private static final long serialVersionUID = 1L;
	
//	@XmlElement(name = "_id") 
	private String _id;
	
	private String cardHolderName;
	
	private String cardNumber;
	
	private String securityCode;
	
	private Date expirationDate;
	
	private int points;
	
	public CardInfo() {
  }

  public CardInfo(String cardHolderName, String cardNumber, String securityCode, Date expirationDate, int points) {
	  super();
	  this.cardHolderName = cardHolderName;
	  this.cardNumber = cardNumber;
	  this.securityCode = securityCode;
	  this.expirationDate = expirationDate;
	  this.points = points;
  }
  
  public String get_id() {
	  return _id;
  }

	public String getCardHolderName() {
		return cardHolderName;
	}
	
	public void setCardHolderName(String cardHolderName) {
		this.cardHolderName = cardHolderName;
	}
	
	public String getCardNumber() {
		return cardNumber;
	}
	
	public void setCardNumber(String cardNumber) {
		this.cardNumber = cardNumber;
	}
	
	public String getSecurityCode() {
		return securityCode;
	}
	
	public void setSecurityCode(String securityCode) {
		this.securityCode = securityCode;
	}
	
	public Date getExpirationDate() {
		return expirationDate;
	}
	
	public void setExpirationDate(Date expirationDate) {
		this.expirationDate = expirationDate;
	}
	
	public int getPoints() {
		return points;
	}
	
	public void setPoints(int points) {
		this.points = points;
	}
  
}
