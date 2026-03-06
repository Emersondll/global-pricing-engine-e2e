package context;

import static configs.EnvironmentConstants.ENVIRONMENT_UAT;
import static java.lang.ThreadLocal.withInitial;

import helpers.GenerateAuthorization;

public class TestContextService {

	private static final TestContextService INSTANCE = new TestContextService();

	private static final String DEFAULT_AUTHORIZATION = GenerateAuthorization.getInstance().execute(ENVIRONMENT_UAT, null);

	private final TestContext globalTestContext = new TestContext();
	private final ThreadLocal<TestContext> testContexts = withInitial(TestContextService::initializeTestContext);

	private TestContextService() {

	}

	private static TestContext initializeTestContext() {

		final TestContext testContext = new TestContext();
		testContext.setAuthorization(DEFAULT_AUTHORIZATION);

		return testContext;
	}

	public static TestContextService getInstance() {

		return INSTANCE;
	}

	public TestContext getTestContext() {

		return testContexts.get();
	}

	public TestContext getGlobalTestContext() {

		return globalTestContext;
	}

	public void reset() {

		testContexts.remove();
	}
}