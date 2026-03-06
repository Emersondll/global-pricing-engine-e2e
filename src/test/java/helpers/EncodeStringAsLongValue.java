package helpers;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

public class EncodeStringAsLongValue {

	private static final EncodeStringAsLongValue INSTANCE = new EncodeStringAsLongValue();

	private EncodeStringAsLongValue() {

	}

	public static EncodeStringAsLongValue getInstance() {

		return INSTANCE;
	}

	public long execute(final String value) {

		try {
			final MessageDigest digest = MessageDigest.getInstance("SHA-256");
			final byte[] hash = digest.digest(value.getBytes());

			return simplifyHashToLong(hash);
		} catch (final NoSuchAlgorithmException e) {
			e.printStackTrace();
		}

		return 0;
	}

	private long simplifyHashToLong(final byte[] hash) {

		long result = 0;
		for (int i = 0; i < 8 && i < hash.length; i++) {
			result <<= 8;
			result |= (hash[i] & 0xFF);
		}

		return result;
	}

}
