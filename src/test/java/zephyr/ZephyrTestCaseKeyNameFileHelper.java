package zephyr;

import static java.util.Objects.isNull;

import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.DeserializationFeature;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.json.JsonMapper;

public class ZephyrTestCaseKeyNameFileHelper {

	private static final List<ZephyrTestCase> zephyrTestCaseKeyNameList = new ArrayList<>();
	private static ZephyrTestCaseKeyNameFileHelper instance;

	private ZephyrTestCaseKeyNameFileHelper() {

	}

	public static ZephyrTestCaseKeyNameFileHelper getInstance() {

		if (isNull(instance)) {
			instance = new ZephyrTestCaseKeyNameFileHelper();
		}

		return instance;
	}

	public void readFromTestCaseNamesFile() throws IOException {

		try (final FileReader fileReader = new FileReader(ZephyrConstants.TEST_CASE_KEY_NAME_FILE_PATH)) {
			final ObjectMapper objectMapper = createObjectMapper();
			zephyrTestCaseKeyNameList.addAll(objectMapper.readValue(fileReader, new TypeReference<>() {
			}));
		}

	}

	public void writeToMapTestCaseNamesFile() throws IOException {

		try (final FileWriter fileReader = new FileWriter(ZephyrConstants.TEST_CASE_KEY_NAME_FILE_PATH)) {
			final ObjectMapper objectMapper = createObjectMapper();
			objectMapper.writeValue(fileReader, zephyrTestCaseKeyNameList);
		}
	}

	public void addToZephyrTestCaseKeyNameList(final ZephyrTestCase zephyrTestCase) {

		zephyrTestCaseKeyNameList.add(zephyrTestCase);
	}

	public List<ZephyrTestCase> getZephyrTestCaseKeyNameList() {

		return zephyrTestCaseKeyNameList;
	}

	private ObjectMapper createObjectMapper() {

		return JsonMapper.builder()
			.findAndAddModules()
			.configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false)
			.build();
	}
}
