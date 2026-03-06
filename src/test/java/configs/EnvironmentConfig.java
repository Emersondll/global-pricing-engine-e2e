package configs;

import static configs.EnvironmentConstants.ACCOUNT_ENV_PARAMETER;
import static configs.EnvironmentConstants.CHARGE_ENV_PARAMETER;
import static configs.EnvironmentConstants.COMBO_ENV_PARAMETER;
import static configs.EnvironmentConstants.DEAL_ENV_PARAMETER;
import static configs.EnvironmentConstants.EMPTY_ENV_PARAMETER;
import static configs.EnvironmentConstants.ENFORCEMENT_ENV_PARAMETER;
import static configs.EnvironmentConstants.ENVIRONMENT_LOCAL;
import static configs.EnvironmentConstants.ITEM_ENV_PARAMETER;
import static configs.EnvironmentConstants.PRICE_ENV_PARAMETER;
import static configs.EnvironmentConstants.PRICING_ENGINE_ENV_PARAMETER;
import static configs.EnvironmentConstants.PROMOTION_ENV_PARAMETER;

import java.util.Objects;

public class EnvironmentConfig {

	private static final String dealEnvironment = System.getProperty(DEAL_ENV_PARAMETER);
	private static final String chargeEnvironment = System.getProperty(CHARGE_ENV_PARAMETER);
	private static final String comboEnvironment = System.getProperty(COMBO_ENV_PARAMETER);
	private static final String priceEnvironment = System.getProperty(PRICE_ENV_PARAMETER);
	private static final String pricingEngineEnvironment = System.getProperty(PRICING_ENGINE_ENV_PARAMETER);
	private static final String accountEnvironment = System.getProperty(ACCOUNT_ENV_PARAMETER);
	private static final String itemEnvironment = System.getProperty(ITEM_ENV_PARAMETER);
	private static final String enforcementEnvironment = System.getProperty(ENFORCEMENT_ENV_PARAMETER);
	private static final String emptyEnvironment = System.getProperty(EMPTY_ENV_PARAMETER);
	private static final String promotionEnvironment = System.getProperty(PROMOTION_ENV_PARAMETER);

	public static boolean runDealServiceLocally() {

		return Objects.nonNull(dealEnvironment) && ENVIRONMENT_LOCAL.equalsIgnoreCase(dealEnvironment);
	}

	public static boolean runChargeServiceLocally() {

		return Objects.nonNull(chargeEnvironment) && ENVIRONMENT_LOCAL.equalsIgnoreCase(chargeEnvironment);
	}

	public static boolean runComboServiceLocally() {

		return Objects.nonNull(comboEnvironment) && ENVIRONMENT_LOCAL.equalsIgnoreCase(comboEnvironment);
	}

	public static boolean runPriceServiceLocally() {

		return Objects.nonNull(priceEnvironment) && ENVIRONMENT_LOCAL.equalsIgnoreCase(priceEnvironment);
	}

	public static boolean runPricingEngineLocally() {

		return Objects.nonNull(pricingEngineEnvironment) && ENVIRONMENT_LOCAL.equalsIgnoreCase(pricingEngineEnvironment);
	}

	public static boolean runAccountServiceLocally() {

		return Objects.nonNull(accountEnvironment) && ENVIRONMENT_LOCAL.equalsIgnoreCase(accountEnvironment);
	}

	public static boolean runItemServiceLocally() {

		return Objects.nonNull(itemEnvironment) && ENVIRONMENT_LOCAL.equalsIgnoreCase(itemEnvironment);
	}

	public static boolean runEnforcementServiceLocally() {

		return Objects.nonNull(enforcementEnvironment) && ENVIRONMENT_LOCAL.equalsIgnoreCase(enforcementEnvironment);
	}

	public static boolean runEmptyServiceLocally() {

		return Objects.nonNull(emptyEnvironment) && ENVIRONMENT_LOCAL.equalsIgnoreCase(emptyEnvironment);
	}

	public static boolean runPromotionServiceLocally() {

		return Objects.nonNull(promotionEnvironment) && ENVIRONMENT_LOCAL.equalsIgnoreCase(promotionEnvironment);
	}
}
