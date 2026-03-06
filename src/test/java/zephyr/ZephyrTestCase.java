package zephyr;

public class ZephyrTestCase {

	private String scenarioName;
	private String scenarioKey;

	public ZephyrTestCase(final String scenarioName, final String scenarioKey) {

		this.scenarioKey = scenarioKey;
		this.scenarioName = scenarioName;
	}

	public ZephyrTestCase() {

	}

	public String getScenarioKey() {

		return scenarioKey;
	}

	public void setScenarioKey(final String scenarioKey) {

		this.scenarioKey = scenarioKey;
	}

	public String getScenarioName() {

		return scenarioName;
	}

	public void setScenarioName(final String scenarioName) {

		this.scenarioName = scenarioName;
	}
}
