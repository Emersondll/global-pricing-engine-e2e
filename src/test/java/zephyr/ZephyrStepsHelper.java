package zephyr;

import static java.util.Objects.isNull;

import java.lang.reflect.Field;
import java.util.List;
import java.util.stream.Collectors;

import io.cucumber.core.backend.TestCaseState;
import io.cucumber.java.Scenario;
import io.cucumber.plugin.event.PickleStepTestStep;
import io.cucumber.plugin.event.TestCase;
import io.cucumber.plugin.event.TestStep;

public class ZephyrStepsHelper {

	public static ZephyrStepsHelper instance;

	private ZephyrStepsHelper() {

	}

	public static ZephyrStepsHelper getInstance() {

		if (isNull(instance)) {
			instance = new ZephyrStepsHelper();
		}

		return instance;
	}

	public List<String> getStepsFrom(final Scenario scenario) throws NoSuchFieldException, IllegalAccessException {

		final TestCaseState tcs = extractTestCaseStateFromDelegate(scenario);
		final List<TestStep> testSteps = extractTestStepsFromTestCaseState(tcs);

		return testSteps.stream()
			.filter(x -> x instanceof PickleStepTestStep)
			.map(x -> String.format("%s %s", ((PickleStepTestStep) x).getStep().getKeyword(), ((PickleStepTestStep) x).getStep().getText()))
			.collect(Collectors.toUnmodifiableList());
	}

	private TestCaseState extractTestCaseStateFromDelegate(final Scenario scenario) throws IllegalAccessException, NoSuchFieldException {

		final Field delegateField = scenario.getClass().getDeclaredField("delegate");
		delegateField.setAccessible(true);
		return (TestCaseState) delegateField.get(scenario);
	}

	private List<TestStep> extractTestStepsFromTestCaseState(final TestCaseState tcs) throws IllegalAccessException, NoSuchFieldException {

		final Field testCaseField = tcs.getClass().getDeclaredField("testCase");
		testCaseField.setAccessible(true);
		final TestCase testCase = (TestCase) testCaseField.get(tcs);
		return testCase.getTestSteps();
	}

}