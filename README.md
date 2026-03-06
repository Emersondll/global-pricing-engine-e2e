# Running e2e tests on the local environment

## Prerequisites

1. Install or update docker-compose to version 1.29.2. It will be needed as our docker-compose.yml file uses newly introduced features.

2. Installation instructions can be found here: https://docs.docker.com/compose/install/

3. To run the correct version of a microservice you must generate its docker image every time it suffers a change.

4. In the root folder run:
   
   ```
   mvn clean install
   ```

***Important:*** If your local service is not reflecting a recently added change, then probably an updated docker image should be generated! 
All microservices related to our project must be located at the same level as global-pricing-engine-e2e. Example: price-service, deal-service, global-pricing-engine-e2e, etc, must be in the same directory.

## Update environment payloads manually

To run the E2E tests with the same configuration we have in the BEES MicroServices UAT environment, we need to verify (and if necessary) update the `.env` payloads values ​​for all microservices. We must always keep these settings up to date.
For example, in pricing-engine we have toggle settings. Your content must be exactly as it is in UAT.
```
Pricing Engine api.env:

# price configuration
ENABLE_EXTRA_EMPTY_DISCOUNT=co,ec,hn,sv  

UAT Bees Micro-Services values.yaml:

toggle:
  configuration:    
    enableExtraEmptyDiscount: co,ec,hn,sv
```

## Update response payloads automatically 

Sometimes there are changes in the response of microservices that affect the execution of e2e tests. For example, if a new field is added to the pricing engine response, all existing tests validating that endpoint will stop until the new field is added to the comparison JSON files. It can require a huge effort to update all of those files. In order to make it easier to update the files we can run the following command:

   ```
   mvn clean install -Dupdate=true -Dfolder=folder-name
   ```

The first parameter indicates that we want to update the JSON files, and the second parameter indicates files from which folders are going to be updated

***Important:*** Remember that this command will automatically update the files based on the response of the microservices. So it is important to double-check the files updated to make sure that the values in it are correct and also it's required to create tests that will cover the business of the new field added.

## Running the micro-services locally

**1. Selecting the desired services:**

   For run the microservices locally we use docker-compose running docker containers for each service that we need. You only need to build ([step #2](#Prerequisites)) the services that you want to execute locally.

   Go to file `.env` in the root folder of project **global-pricing-engine-e2e** and update the variable `COMPOSE_FILE`. Keep only the services that you want to run locally (splitted by colon `:`):
   ```
   COMPOSE_FILE=docker-compose.yml:${DEAL_FILE}
   ```
   The example above will run the pricing-engine and deal-service in docker-compose.

***Important***: The first value `docker-compose.yml` cannot be removed from the variable `COMPOSE_FILE`. This file contains the pricing-engine configuration, that is, if you are going to run only the pricing-engine locally, the declaration of the environment variable must be:

   ```
   COMPOSE_FILE=docker-compose.yml
   ```
**2. Setting environment variables:**

   You may need to update environment variables of the services to activate some feature code toggle or even to update data tiers URLs for pricing-engine. Go to the folder `environment` in and select the desired service (price, deal, combo, charge, etc). For the data tiers we have one environment file for each module (relay, consumer and api) and for pricing-engine there is only one environment file (api.env)
   
   You can open the desired files and update the values or insert new variables according to `application.yml` file of the project.

   ***Important***: If you are running any data-tier locally, you will need to update the pricing-engine environment file to point to this local data-tier and point the others to a remote environment (UAT or SIT).

**3. Running the services locally:**

   When we want to run some data tier service we need to indicates to docker-compose that we need the MongoDB and RabbitMQ locally.

   Let's say we want to run the price-service locally, so we should navigate the root folder of the **global-pricing-engine-e2e** and invoke the docker-compose using the --profile parameter:

   ```
   docker-compose --profile data-tier up
   ```

   A few things that are important to mention:

   - The pricing-engine service is always started no matter the chosen profile
   - You can access the MongoDB database by connecting to the default address localhost:27017
   - RabbitMq is also available at http://localhost:15672

## Running the e2e tests locally

When we have all necessary services running locally, we can properly run the e2e tests locally.

To do so, we will also use some parameters to tell our tests which environment we want to use, currently, by default we use the UAT environment if no extra config is sent.

Assuming that we want to run all tests against our local environment we should use in another terminal:

```
mvn clean verify -Dprice.env=LOCAL -Ddeal.env=LOCAL -Dcharge.env=LOCAL
```

By doing this, the local pricing-engine will be implicitly used. If we decide to use only the pricing-engine locally and use the UAT data tier we must specify only the pricing engine in the command by doing:

```
mvn clean verify -Dpricing.env=LOCAL
```

However, if we want to run the component tests in the **IntelliJ** we could skip running those commands above and just replace the EnvironmentConfig.java methods (that involves the microservices we are testing) and forcing them to return true. 

If we decide to run the pricing engine we should do as:

```
public static boolean runPricingEngineLocally() {
	return true;
	//return Objects.nonNull(pricingEngineEnvironment) && ENVIRONMENT_LOCAL.equalsIgnoreCase(pricingEngineEnvironment);
}
```

## Using the micro-services locally

You can run the services locally and access them through the following addresses:

**pricing-engine:**
- api: http://localhost:5000/swagger-ui.html

**price-service:**
- relay: http://localhost:5001/swagger-ui.html
- api: http://localhost:5003/swagger-ui.html

**deal-service:**
- relay: http://localhost:5004/swagger-ui.html
- api: http://localhost:5006/swagger-ui.html

**charge-service:**
- relay: http://localhost:5007/swagger-ui.html
- api: http://localhost:5009/swagger-ui.html

## Debugging pricing-engine locally

In situations where there is a need to debug the pricing-engine that is running locally, we must follow these steps:

**1. In the "pricing-engine" application:**
   - Run `mvn clean install` to ensure that the container version will be synchronized with the application code version.
- Configure the "Remote JVM Debug" in the IDE (intelliJ) to synchronize the debug port.:
   - In the "Run" Menu, "Edit Configurations" option, click on "Remote JVM Debug" option, "Add new run configuration"
   - In the following screen, put a name
   - In the "Configuration" tab, "Debbuger Mode" field, select option "Attach to Remote JVM", Host: "localhost", Port: "6005", field "Command line arguments for remote JVM:" add the content:
    ```
    -agentlib:jdwp=transport=dt_socket,server=y,suspend=n ,address=*:6005
    ```
   - "JDK 9 or later" option selected
   - Field "use module classpath:", select option `<no module>`
   - Click on "Apply" button and finish with "OK" button!
- Make sure to leave this "Remote JVM Debug" configuration created, already pre-selected in the "Run/Debug Configurations" field in intelliJ's top tools menu (next to the "Build Project" hammer).

**2. In the "global-pricing-engine-e2e" application:**
- Run the command "docker-compose up" to upload the application

**3. In the "pricing-engine" application again:**
- Click on Debug Mode!
- Example URL for local simulation tests (for auxiliary use in Postman for example): "localhost:5000/v2/simulation/"