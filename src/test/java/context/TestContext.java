package context;

import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import io.restassured.http.Method;
import io.restassured.response.Response;

public class TestContext {

	private static String GLOBAL_ID_PREFIX = null;

	private final Map<Integer, String> dynamicVendorAccountIdByKey;
	private final Map<Integer, String> dynamicContractIdByKey;
	private final Map<Integer, String> dynamicPriceListIdByKey;
	private final Map<Integer, String> dynamicTaxIdByKey;
	private final Map<Integer, String> dynamicVendorDeliveryCenterIdByKey;
	private final Map<Integer, String> dynamicDeliveryCenterIdByKey;
	private final Map<String, String> authorizationByVendorId;
	private final Map<Integer, String> dynamicEnforcementPlacementIdByKey;
	private final Map<Integer, String> dynamicComboAccountPlatformIdByKey;
	private final Map<Integer, String> dynamicComboDeliveryCenterPlatformIdByKey;
	private final Map<String, String> vendorIdByKey;
	private String folder;
	private String payloadFileName;
	private LinkedHashMap<String, Object> requestHeaders;
	private LinkedHashMap<String, Object> requestParams;
	private Response response;
	private Method requestMethod;
	private String requestEndpoint;
	private String authorization;
	private String lastAuthorization;
	private String country;
	private String taxId;
	private String timeZone;
	private String dynamicVendorAccountId;
	private String dynamicVendorDeliveryCenterId;
	private String dynamicPriceListId;
	private String dynamicContractId;
	private String dynamicDeliveryCenterPlatformId;
	private DataCreatedInTestContext dataCreatedInTestContext;
	private Integer customSecondsToAwait;
	private String uniqueId;

	public TestContext() {

		authorizationByVendorId = new HashMap<>();
		requestHeaders = new LinkedHashMap<>();
		requestParams = new LinkedHashMap<>();
		dataCreatedInTestContext = new DataCreatedInTestContext();
		dynamicContractIdByKey = new HashMap<>();
		dynamicVendorAccountIdByKey = new HashMap<>();
		dynamicVendorDeliveryCenterIdByKey = new HashMap<>();
		dynamicDeliveryCenterIdByKey = new HashMap<>();
		dynamicPriceListIdByKey = new HashMap<>();
		dynamicTaxIdByKey = new HashMap<>();
		dynamicEnforcementPlacementIdByKey = new HashMap<>();
		dynamicComboAccountPlatformIdByKey = new HashMap<>();
		dynamicComboDeliveryCenterPlatformIdByKey = new HashMap<>();
		vendorIdByKey = new HashMap<>();
	}

	public String getGlobalIdPrefix() {

		return GLOBAL_ID_PREFIX;
	}

	public void setGlobalIdPrefix(final String value) {

		if (value == null) {
			throw new IllegalArgumentException("The GLOBAL_ID_PREFIX value cannot be null");
		}

		if (GLOBAL_ID_PREFIX == null) {
			GLOBAL_ID_PREFIX = value;
		} else {
			throw new IllegalCallerException("The GLOBAL_ID_PREFIX can be configured just once");
		}
	}

	public String getFolder() {

		return folder;
	}

	public void setFolder(final String folder) {

		this.folder = folder;
	}

	public String getPayloadFileName() {

		return payloadFileName;
	}

	public void setPayloadFileName(final String payloadFileName) {

		this.payloadFileName = payloadFileName;
	}

	public LinkedHashMap<String, Object> getRequestHeaders() {

		return requestHeaders;
	}

	public void setRequestHeaders(final LinkedHashMap<String, Object> requestHeaders) {

		this.requestHeaders = requestHeaders;
	}

	public LinkedHashMap<String, Object> getRequestParams() {

		return requestParams;
	}

	public void setRequestParams(final LinkedHashMap<String, Object> requestParams) {

		this.requestParams = requestParams;
	}

	public Response getResponse() {

		return response;
	}

	public void setResponse(final Response response) {

		this.response = response;
	}

	public Method getRequestMethod() {

		return requestMethod;
	}

	public void setRequestMethod(final Method requestMethod) {

		this.requestMethod = requestMethod;
	}

	public String getRequestEndpoint() {

		return requestEndpoint;
	}

	public void setRequestEndpoint(final String requestEndpoint) {

		this.requestEndpoint = requestEndpoint;
	}

	public String getAuthorization() {

		return authorization;
	}

	public void setAuthorization(final String authorization) {

		this.authorization = authorization;
		if (authorization != null) {
			lastAuthorization = authorization;
		}
	}

	public String getLastAuthorization() {

		return lastAuthorization;
	}

	public String getCountry() {

		return country;
	}

	public void setCountry(final String country) {

		this.country = country;
	}

	public DataCreatedInTestContext getDataCreatedInTestContext() {

		return dataCreatedInTestContext;
	}

	public void setDataCreatedInTestContext(final DataCreatedInTestContext dataCreatedInTestContext) {

		this.dataCreatedInTestContext = dataCreatedInTestContext;
	}

	public String getDynamicVendorAccountId() {

		return dynamicVendorAccountId;
	}

	public void setDynamicVendorAccountId(final String dynamicVendorAccountId) {

		this.dynamicVendorAccountId = dynamicVendorAccountId;
	}

	public void addDynamicVendorAccountIdByKey(final Integer key, final String dynamicVendorAccountId) {

		dynamicVendorAccountIdByKey.put(key, dynamicVendorAccountId);
	}

	public String getDynamicVendorAccountIdByKey(final Integer key) {

		return dynamicVendorAccountIdByKey.get(key);
	}

	public String getDynamicVendorDeliveryCenterId() {

		return dynamicVendorDeliveryCenterId;
	}

	public void setDynamicVendorDeliveryCenterId(final String dynamicVendorDeliveryCenterId) {

		this.dynamicVendorDeliveryCenterId = dynamicVendorDeliveryCenterId;
	}

	public void addDynamicVendorDeliveryCenterIdByKey(final Integer key, final String dynamicVendorDeliveryCenterId) {

		dynamicVendorDeliveryCenterIdByKey.put(key, dynamicVendorDeliveryCenterId);
	}

	public String getDynamicVendorDeliveryCenterIdByKey(final Integer key) {

		return dynamicVendorDeliveryCenterIdByKey.get(key);
	}

	public String getDynamicPriceListId() {

		return dynamicPriceListId;
	}

	public void setDynamicPriceListId(final String dynamicPriceListId) {

		this.dynamicPriceListId = dynamicPriceListId;
	}

	public String getDynamicContractId() {

		return dynamicContractId;
	}

	public void setDynamicContractId(final String dynamicContractId) {

		this.dynamicContractId = dynamicContractId;
	}

	public void addDynamicContractIdByKey(final Integer key, final String dynamicContractId) {

		dynamicContractIdByKey.put(key, dynamicContractId);
	}

	public String getDynamicContractIdByKey(final Integer key) {

		return dynamicContractIdByKey.get(key);
	}

	public List<String> getAllDynamicContractIdByKey() {

		final Collection<String> collectionDynamicContractIdByKey = dynamicContractIdByKey.values();
		return new ArrayList<>(collectionDynamicContractIdByKey);
	}

	public String getDynamicDeliveryCenterPlatformId() {

		return dynamicDeliveryCenterPlatformId;
	}

	public void setDynamicDeliveryCenterPlatformId(final String dynamicDeliveryCenterPlatformId) {

		this.dynamicDeliveryCenterPlatformId = dynamicDeliveryCenterPlatformId;
	}

	public void addDynamicDeliveryCenterPlatformIdByKey(final Integer key, final String dynamicDeliveryCenterId) {

		dynamicDeliveryCenterIdByKey.put(key, dynamicDeliveryCenterId);
	}

	public String getDynamicDeliveryCenterIdByKey(final Integer key) {

		return dynamicDeliveryCenterIdByKey.get(key);
	}

	public String getDynamicPriceListIdByKey(final Integer key) {

		return dynamicPriceListIdByKey.get(key);
	}

	public void addDynamicPriceListIdByKey(final Integer key, final String priceListId) {

		dynamicPriceListIdByKey.put(key, priceListId);
	}

	public String getDynamicTaxIdByKey(final Integer key) {

		return dynamicTaxIdByKey.get(key);
	}

	public void addDynamicTaxIdByKey(final Integer key, final String taxId) {

		dynamicTaxIdByKey.put(key, taxId);
	}

	public void addDynamicComboAccountPlatformIdByKey(final Integer key, final String dynamicComboAccountPlatformId) {

		dynamicComboAccountPlatformIdByKey.put(key, dynamicComboAccountPlatformId);
	}

	public String getDynamicComboAccountPlatformIdByKey(final Integer key) {

		return dynamicComboAccountPlatformIdByKey.get(key);
	}

	public List<String> getAllDynamicComboAccountPlatformIds() {

		final Collection<String> collectionDynamicContractIdByKey = dynamicComboAccountPlatformIdByKey.values();
		return new ArrayList<>(collectionDynamicContractIdByKey);
	}

	public void addDynamicComboDeliveryCenterPlatformIdByKey(final Integer key, final String dynamicComboDeliveryCenterPlatformId) {

		dynamicComboDeliveryCenterPlatformIdByKey.put(key, dynamicComboDeliveryCenterPlatformId);
	}

	public String getDynamicComboDeliveryCenterPlatformIdByKey(final Integer key) {

		return dynamicComboDeliveryCenterPlatformIdByKey.get(key);
	}

	public List<String> getAllDynamicComboDeliveryCenterPlatformIds() {

		final Collection<String> collectionDynamicDeliveryCenterIdByKey = dynamicComboDeliveryCenterPlatformIdByKey.values();
		return new ArrayList<>(collectionDynamicDeliveryCenterIdByKey);
	}

	public void addAuthorizationByVendorId(final String vendorId, final String token) {

		authorizationByVendorId.put(vendorId, token);
	}

	public void addDynamicEnforcementPlatformIdByKey(final Integer key, final String dynamicEnforcementPlacementId) {

		dynamicEnforcementPlacementIdByKey.put(key, dynamicEnforcementPlacementId);
	}

	public String getDynamicEnforcementPlatformIdByKey(final Integer key) {

		return dynamicEnforcementPlacementIdByKey.get(key);
	}

	public String getAuthorizationByVendorId(final String vendorId) {

		return authorizationByVendorId.get(vendorId);
	}

	public String getTaxId() {

		return taxId;
	}

	public void setTaxId(final String taxId) {

		this.taxId = taxId;
	}

	public String getTimeZone() {

		return timeZone;
	}

	public void setTimeZone(final String timeZone) {

		this.timeZone = timeZone;
	}

	public void addVendorIdByKey(final String key, final String vendorId) {

		vendorIdByKey.put(key, vendorId);
	}

	public String getVendorIdByKey(final String key) {

		return vendorIdByKey.get(key);
	}

	public Integer getCustomSecondsToAwait() {

		return customSecondsToAwait;
	}

	public void setCustomSecondsToAwait(final Integer customSecondsToAwait) {

		this.customSecondsToAwait = customSecondsToAwait;
	}

	public String getUniqueId() {

		return uniqueId;
	}

	public void setUniqueId(final String uniqueId) {

		this.uniqueId = uniqueId;
	}
}
