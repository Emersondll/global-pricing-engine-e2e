package zephyr;

import static io.restassured.RestAssured.given;
import static java.lang.String.format;
import static java.util.Objects.isNull;
import static org.apache.commons.lang3.ObjectUtils.isNotEmpty;
import static zephyr.ZephyrConstants.ZEPHYR_AUTHORIZATION;

import java.util.Map;

import io.restassured.http.Method;
import io.restassured.response.Response;
import io.restassured.specification.RequestSpecification;

public class ZephyrRequestHelper {

	public static ZephyrRequestHelper instance;

	private ZephyrRequestHelper() {

	}

	public static ZephyrRequestHelper getInstance() {

		if (isNull(instance)) {
			instance = new ZephyrRequestHelper();
		}

		return instance;
	}

	public Response doRequest(final Method method, final String payload, final String endpoint) {

		return doRequest(null, method, payload, endpoint);
	}

	public Response doRequest(final Map<String, ?> params, final Method method, final String payload, final String endpoint) {

		final RequestSpecification request = given();

		if (isNotEmpty(payload)) {
			request.body(payload);
		}
		if (isNotEmpty(params)) {
			request.queryParams(params);
		}

		request.header(ZephyrConstants.AUTHORIZATION_HEADER, ZEPHYR_AUTHORIZATION);
		request.header(ZephyrConstants.CONTENT_TYPE_HEADER, ZephyrConstants.APPLICATION_JSON);

		return request.when().request(method, format(ZephyrConstants.ZEPHYR_BASE_URL_FORMAT, endpoint));
	}
}
