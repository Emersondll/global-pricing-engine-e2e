package helpers;

import static configs.EnvironmentConstants.POLL_INTERVAL_IN_SECONDS;
import static configs.EnvironmentConstants.SECONDS_TO_AWAIT;
import static helpers.TestConstants.ACCESS_TOKEN_REGEX;
import static helpers.TestConstants.CLIENT_ID_PARAMETER;
import static helpers.TestConstants.CLIENT_SECRET_PARAMETER;
import static helpers.TestConstants.CONTENT_TYPE_HEADER;
import static helpers.TestConstants.GRANT_TYPE_PARAMETER;
import static helpers.TestConstants.REQUEST_TRACE_ID_HEADER;
import static helpers.TestConstants.SCOPE_PARAMETER;
import static io.restassured.RestAssured.given;
import static java.util.concurrent.TimeUnit.SECONDS;
import static org.awaitility.Awaitility.await;

import java.time.Duration;
import java.util.concurrent.atomic.AtomicReference;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import io.restassured.filter.log.LogDetail;
import io.restassured.response.Response;

public class GenerateAuthorization {

	private static final Logger LOGGER = LoggerFactory.getLogger(GenerateAuthorization.class);

	private static final GenerateAuthorization INSTANCE = new GenerateAuthorization();

	private GenerateAuthorization() {

	}

	public static GenerateAuthorization getInstance() {

		return INSTANCE;
	}

	public String execute(final String environment, final String vendorId) {

		final AtomicReference<String> tokenReference = new AtomicReference<>();

		await().pollInterval(POLL_INTERVAL_IN_SECONDS, SECONDS).pollDelay(Duration.ZERO).atMost(SECONDS_TO_AWAIT, SECONDS)
				.untilAsserted(() -> {
					final Response response = doRequest(environment, vendorId);

					response.then().log().ifValidationFails(LogDetail.ALL).statusCode(200);

					final Pattern patternTransId4 = Pattern.compile(ACCESS_TOKEN_REGEX);
					final Matcher matcherTransId4 = patternTransId4.matcher(response.getBody().asPrettyString());
					String token = "";
					if (matcherTransId4.find()) {
						token = matcherTransId4.group(1);
					}

					LOGGER.info("Generated vendorId Token for vendorId: " + vendorId + " token: " + token);
					LOGGER.info("=== Finishing to generate vendorId token ===");

					tokenReference.set("Bearer " + token);
				});

		return tokenReference.get();
	}

	public Response doRequest(final String environment, final String vendorId) {

		LOGGER.info("=== Starting to generate vendorId token for vendor {} and environment {} ===", vendorId, environment);

		final VendorEnum vendor = VendorEnum.getVendor(vendorId, environment);

		final Response response = given()
				.header(CONTENT_TYPE_HEADER, "application/x-www-form-urlencoded")
				.header(REQUEST_TRACE_ID_HEADER, "vendorIdRT1")
				.formParam(GRANT_TYPE_PARAMETER, "client_credentials")
				.formParam(CLIENT_ID_PARAMETER, vendor.getClientId())
				.formParam(CLIENT_SECRET_PARAMETER, vendor.getClientSecret())
				.formParam(SCOPE_PARAMETER, "openid")
				.when().post("https://services-" + environment + ".bees-platform.dev/api/auth/token");

		return response;
	}

}
