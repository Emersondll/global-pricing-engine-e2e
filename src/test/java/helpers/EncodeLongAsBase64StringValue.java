package helpers;

public class EncodeLongAsBase64StringValue {

	private static final EncodeLongAsBase64StringValue INSTANCE = new EncodeLongAsBase64StringValue();

	private EncodeLongAsBase64StringValue() {

	}

	public static EncodeLongAsBase64StringValue getInstance() {

		return INSTANCE;
	}

	public String execute(final long codedLong) {

		return String.format("%64x", codedLong).trim();
	}

}
