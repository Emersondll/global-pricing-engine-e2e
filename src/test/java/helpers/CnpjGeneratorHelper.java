package helpers;

public class CnpjGeneratorHelper {

	private CnpjGeneratorHelper() {

	}

	public static String generateCnpj(final long baseNumber, final int counter) {

		final String numberAsString = String.valueOf(baseNumber);
		final int n1 = Character.getNumericValue(numberAsString.charAt(1));
		final int n2 = Character.getNumericValue(numberAsString.charAt(2));
		final int n3 = Character.getNumericValue(numberAsString.charAt(3));
		final int n4 = Character.getNumericValue(numberAsString.charAt(4));
		final int n5 = Character.getNumericValue(numberAsString.charAt(5));
		final int n6 = Character.getNumericValue(numberAsString.charAt(6));
		final int n7 = Character.getNumericValue(numberAsString.charAt(7));
		final int n8 = Character.getNumericValue(numberAsString.charAt(8));
		final int n9 = Character.getNumericValue(numberAsString.charAt(9));

		// The n10, n11 and n12 values will take the three last digits from the counter value like that:
		// * if the counter value is 123, so the n10, n11 and n12 will be 1, 2 and 3.
		// * if the counter value is 98765, so the n10, n11 and n12 will be 7, 6 and 5.
		final int formattedCounter = counter % 1000;
		final int n10 = formattedCounter / 100;
		final int n11 = (formattedCounter - (n10 * 100)) / 10;
		final int n12 = (formattedCounter - (n10 * 100) - (n11 * 10));

		int d1 = n12 * 2 + n11 * 3 + n10 * 4 + n9 * 5 + n8 * 6 + n7 * 7 + n6 * 8 + n5 * 9 + n4 * 2 + n3 * 3 + n2 * 4 + n1 * 5;

		d1 = 11 - ((d1 % 11));

		if (d1 >= 10) {
			d1 = 0;
		}

		int d2 = d1 * 2 + n12 * 3 + n11 * 4 + n10 * 5 + n9 * 6 + n8 * 7 + n7 * 8 + n6 * 9 + n5 * 2 + n4 * 3 + n3 * 4 + n2 * 5 + n1 * 6;

		d2 = 11 - ((d2 % 11));

		if (d2 >= 10) {
			d2 = 0;
		}

		return "" + n1 + n2 + n3 + n4 + n5 + n6 + n7 + n8 + n9 + n10 + n11 + n12 + d1 + d2;
	}
}
