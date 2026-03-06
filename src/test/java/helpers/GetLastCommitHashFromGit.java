package helpers;

import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStreamReader;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class GetLastCommitHashFromGit {

	private static final Logger LOGGER = LoggerFactory.getLogger(GetLastCommitHashFromGit.class);

	private static final GetLastCommitHashFromGit INSTANCE = new GetLastCommitHashFromGit();

	private GetLastCommitHashFromGit() {

	}

	public static GetLastCommitHashFromGit getInstance() {

		return INSTANCE;
	}

	public String execute() {

		final String dir = System.getProperty("user.dir");

		try {
			final Runtime runtime = Runtime.getRuntime();

			final String branch = executeCommand(dir, runtime, "git rev-parse --abbrev-ref HEAD");
			LOGGER.info("Actual branch from git: " + branch);

			final String hash = executeCommand(dir, runtime, "git log -1 --pretty=format:%h");
			LOGGER.info("Last commit hash from git: " + hash);

			return branch + "_" + hash;
		} catch (final IOException e) {
			throw new RuntimeException("Failed to get last commit hash from git.", e);
		}
	}

	private String executeCommand(final String dir, final Runtime runtime, final String command) throws IOException {

		final Process process = runtime.exec(command, null, new File(dir));

		final String result;
		try (final BufferedReader bufferedReader = new BufferedReader(new InputStreamReader(process.getInputStream()))) {
			result = bufferedReader.readLine();
		}

		return result;
	}
}
