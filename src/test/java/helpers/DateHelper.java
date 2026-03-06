package helpers;

import java.text.SimpleDateFormat;
import java.time.OffsetDateTime;
import java.time.ZonedDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Date;

public class DateHelper {

	private DateHelper() {

	}

	public static String dateFormatter(final Date date, final String pattern) {

		final SimpleDateFormat dateFormat = new SimpleDateFormat(pattern);
		return dateFormat.format(date);
	}

	public static String dateFormatter(final ZonedDateTime date, final String pattern) {

		final DateTimeFormatter dateFormat = DateTimeFormatter.ofPattern(pattern);
		return dateFormat.format(date);
	}
}
