/*******************************************************************************
* Copyright (c) 2017 IBM Corp.
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

package com.acmeair.config;

import com.acmeair.service.CardService;

import java.util.logging.Logger;

import javax.inject.Inject;
import javax.json.Json;
import javax.json.JsonArray;
import javax.json.JsonBuilderFactory;
import javax.ws.rs.Consumes;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.Response;

import org.eclipse.microprofile.openapi.models.Paths;
import org.eclipse.microprofile.rest.client.inject.RegisterRestClient;

//@Path("/cardService")
//@Produces("application/json")
public interface CardConfiguration{
	
    
//  Logger logger = Logger.getLogger(CardConfiguration.class.getName());
//
////  @Inject
////  CardService cardService;
//
//  @GET
//  @Path("/cardServiceHealthCheck")
//  @Produces("application/json")
//  public Response healthCheck();
//  
//  /**
//   * Return active db impl.
//   */
////  @GET
////  @Path("/activeDataService")
////  @Produces("application/json")
////  public Response getActiveDataServiceInfo() {
////    try {
////      logger.fine("Get active Data Service info");
////      return  Response.ok(cardService.getServiceType()).build();
////    } catch (Exception e) {
////      e.printStackTrace();
////      return Response.ok("Unknown").build();
////    }
////  }
//  
//  /**
//   * Return runtim info.
//   */
//  @GET
//  @Path("/runtime")
//  @Produces("application/json")
//  public String getRuntimeInfo();
  
}
