package helpers;

import java.util.Objects;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class TimeZoneHelper {

	private static final Logger LOGGER = LoggerFactory.getLogger(TimeZoneHelper.class);

	private TimeZoneHelper() {

	}

	public static String getTimeZoneByCountry(final String country) {

		LOGGER.debug("Country received: " + country);
		String timezone = null;
		if (Objects.nonNull(country)) {
			switch (country.toUpperCase()) {
				case "AR":
					timezone = "America/Buenos_Aires";
					break;
				case "BR":
					timezone = "America/Sao_Paulo";
					break;
				case "CA":
					timezone = "America/Toronto";
					break;
				case "CO":
					timezone = "America/Bogota";
					break;
				case "CL":
					timezone = "America/Santiago";
					break;
				case "DO":
					timezone = "America/Santo_Domingo";
					break;
				case "EC":
					timezone = "America/Guayaquil";
					break;
				case "HN":
					timezone = "America/Tegucigalpa";
					break;
				case "MX":
					timezone = "America/Mexico_City";
					break;
				case "PA":
					timezone = "America/Panama";
					break;
				case "PE":
					timezone = "America/Lima";
					break;
				case "PY":
					timezone = "America/Asuncion";
					break;
				case "SV":
					timezone = "America/El_Salvador";
					break;
				case "TZ":
					timezone = "Africa/Dar_es_Salaam";
					break;
				case "UG":
					timezone = "Africa/Kampala";
					break;
				case "US":
					timezone = "America/New_York";
					break;
				case "UY":
					timezone = "America/Montevideo";
					break;
				case "ZA":
					timezone = "Africa/Johannesburg";
					break;
				default:
					break;
			}
		}

		LOGGER.debug("Default Timezone for the country: " + timezone);
		return timezone;
	}
}


