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

import com.acmeair.service.FlightService;

import java.util.logging.Logger;

import javax.inject.Inject;
import javax.json.Json;
import javax.json.JsonArray;
import javax.json.JsonBuilderFactory;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.Response;

@Path("/config")
public class FlightConfiguration {
    
  Logger logger = Logger.getLogger(FlightConfiguration.class.getName());

  @Inject
  FlightService flightService;


  public FlightConfiguration() {
    super();
  }
    
  /**
   * Get the number of flights in the db.
   */
  @GET
  @Path("/countFlights")
  @Produces("application/json")
  public Response countFlights() {
    try {
      String count = flightService.countFlights().toString();
      return Response.ok(count).build();
    } catch (Exception e) {
      e.printStackTrace();
      return Response.ok(-1).build();
    }
  }

  /**
   * Get the number of flight segments in the db.
   */
  @GET
  @Path("/countFlightSegments")
  @Produces("application/json")
  public Response countFlightSegments() {
    try {
      String  count = flightService.countFlightSegments().toString();
      return Response.ok(count).build();
    } catch (Exception e) {
      e.printStackTrace();
      return Response.ok(-1).build();
    }
  }

  /**
   * Get the number of airports in the db.
   */
  @GET
  @Path("/countAirports")
  @Produces("application/json")
  public Response countAirports() {
    
    String  count = flightService.countAirports().toString();  
    try {
      return Response.ok(count).build();
    } catch (Exception e) {
      e.printStackTrace();
      return Response.ok(-1).build();
    }
  }

  /**
   * Get the database type.
   */
  @GET
  @Path("/activeDataService")
  @Produces("application/json")
  public Response getActiveDataServiceInfo() {
    try {
      logger.fine("Get active Data Service info");
      return  Response.ok(flightService.getServiceType()).build();
    } catch (Exception e) {
      e.printStackTrace();
      return Response.ok("Unknown").build();
    }
  }

  /**
   * Get the runtime info.
   */
  @GET
  @Path("/runtime")
  @Produces("application/json")
  public String getRuntimeInfo() {
    JsonBuilderFactory factory = Json.createBuilderFactory(null);
    JsonArray value = factory.createArrayBuilder()
        .add(factory.createObjectBuilder()
            .add("name", "Runtime")
            .add("description", "Java"))
        .add(factory.createObjectBuilder()
            .add("name", "Version")
            .add("description", System.getProperty("java.version")))
        .add(factory.createObjectBuilder()
            .add("name", "Vendor")
            .add("description", System.getProperty("java.vendor")))
        .build();
    
    return value.toString();
  }

  class ServiceData {
    public String name = "";
    public String description = "";
  }
}
