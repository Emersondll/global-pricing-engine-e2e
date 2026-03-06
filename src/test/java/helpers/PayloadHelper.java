package helpers;

import static org.apache.commons.io.FileUtils.writeStringToFile;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.util.ArrayList;
import java.util.List;
import java.util.Objects;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.apache.commons.lang3.tuple.Pair;

public class PayloadHelper {

	public static final String SYSTEM_PROPERTY_UPDATE = "update";
	public static final String SYSTEM_PROPERTY_FOLDER = "folder";
	public static final String TRUE = "true";
	public static final String PLACEHOLDER_REGEX = "\"[a-zA-Z0-9]+\"\\s?:\\s?\"#\\s?([a-zA-Z0-9#_\\-\\s]+)\\s?#\"";
	public static final String JSON_FIELD_NAME_REGEX = "\"[a-zA-Z0-9]+\"\\s?:";
	public static final String JSON_FIELD_VALUE_REGEX = "\\s?\"?(([a-zA-Z0-9\\d]+)(\\W)?_?\\s?)+\"?";
	public static final String FOUR_WHITE_SPACE_REGEX = " {4}";

	public static void writeJsonToFile(final String folder, final String fileName, final String content) throws IOException {

		writeStringToFile(new File("src/test/resources/payloads/" + folder + "/outputs/" + fileName + ".json"),
				content.replaceAll(FOUR_WHITE_SPACE_REGEX, "  "));

	}

	public static boolean shouldUpdateJsonFile(final String folder) {

		final String update = System.getProperty(SYSTEM_PROPERTY_UPDATE);
		final String folderProperty = System.getProperty(SYSTEM_PROPERTY_FOLDER);
		return Objects.nonNull(update) && Objects.nonNull(folderProperty) && update.equalsIgnoreCase(TRUE) && folder
				.equalsIgnoreCase(folderProperty);
	}

	public static String updateFieldsWithPlaceholder(final String expectedResponse, String actualResponse) {

		final List<Pair<String, String>> placeholders = getFieldsWithPlaceholders(expectedResponse);

		for (final Pair<String, String> placeholder : placeholders) {

			final String regex = placeholder.getLeft() + JSON_FIELD_VALUE_REGEX;

			actualResponse = actualResponse.replaceFirst(regex, placeholder.getRight());

		}
		return actualResponse;
	}

	private static List<Pair<String, String>> getFieldsWithPlaceholders(final String expectedResponse) {

		final Pattern placeHolderPattern = Pattern.compile(PLACEHOLDER_REGEX);

		final Matcher placeHolderMatcher = placeHolderPattern.matcher(expectedResponse);

		final List<Pair<String, String>> placeholders = new ArrayList<>();

		while (placeHolderMatcher.find()) {
			final String placeholder = placeHolderMatcher.group();
			final Pattern fieldNamePattern = Pattern.compile(JSON_FIELD_NAME_REGEX);
			final Matcher fieldsNameMatcher = fieldNamePattern.matcher(placeholder);
			if (fieldsNameMatcher.find()) {
				placeholders.add(Pair.of(fieldsNameMatcher.group(), placeholder));
			}

		}
		return placeholders;
	}

	public static String getResponseDataFileContentAsString(final String folder, final String fileName)
			throws IOException {

		return
				Files.readString(new File("src/test/resources/payloads/" + folder + "/outputs/" + fileName + ".json").toPath());
	}

}
