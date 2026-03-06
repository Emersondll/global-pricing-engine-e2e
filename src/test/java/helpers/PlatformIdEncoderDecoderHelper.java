package helpers;

import org.apache.commons.lang3.StringUtils;

import com.abinbev.b2b.commons.platformId.core.PlatformIdEncoderDecoder;
import com.abinbev.b2b.commons.platformId.core.enuns.PlatformIdEnum;
import com.abinbev.b2b.commons.platformId.core.vo.ComboAccountPlatformId;
import com.abinbev.b2b.commons.platformId.core.vo.ComboDeliveryCenterPlatformId;
import com.abinbev.b2b.commons.platformId.core.vo.ComboPlatformId;
import com.abinbev.b2b.commons.platformId.core.vo.ContractPlatformId;
import com.abinbev.b2b.commons.platformId.core.vo.DeliveryCenterPlatformId;
import com.abinbev.b2b.commons.platformId.core.vo.DeliveryWindowPlatformId;
import com.abinbev.b2b.commons.platformId.core.vo.EnforcementPlatformId;
import com.abinbev.b2b.commons.platformId.core.vo.ItemPlatformId;

public class PlatformIdEncoderDecoderHelper {

	private static final PlatformIdEncoderDecoder platformIdEncoderDecoder = new PlatformIdEncoderDecoder();

	private PlatformIdEncoderDecoderHelper() {

	}

	public static String encodeContractId(final String vendorId, final String vendorAccountId) {

		return platformIdEncoderDecoder.encodePlatformId(new ContractPlatformId(vendorId, vendorAccountId));
	}

	public static String encodeDeliveryCenterId(final String vendorId, final String vendorDeliveryCenterId) {

		return platformIdEncoderDecoder.encodePlatformId(new DeliveryCenterPlatformId(vendorId, vendorDeliveryCenterId));

	}

	public static String decodeContractIdToVendorAccountId(final String contractId) {

		final ContractPlatformId contractPlatformId = (ContractPlatformId) platformIdEncoderDecoder
				.decodePlatformId(contractId, PlatformIdEnum.CONTRACT);

		return contractPlatformId.getVendorAccountId();
	}

	public static String getVendorIdFromContractId(final String contractId) {

		final ContractPlatformId contractPlatformId = (ContractPlatformId) platformIdEncoderDecoder
				.decodePlatformId(contractId, PlatformIdEnum.CONTRACT);

		return contractPlatformId.getVendorId();
	}

	public static String getVendorIdFromDeliveryCenterId(final String deliveryCenterId) {

		final DeliveryCenterPlatformId deliveryCenterPlatformId = (DeliveryCenterPlatformId) platformIdEncoderDecoder
				.decodePlatformId(deliveryCenterId, PlatformIdEnum.DELIVERY_CENTER);

		return deliveryCenterPlatformId.getVendorId();
	}

	public static String getComboAccountPlatformId(final String vendorId, final String vendorAccountId, final String vendorComboId) {

		return platformIdEncoderDecoder.encodePlatformId(
				new ComboAccountPlatformId(vendorId, vendorAccountId, vendorComboId));
	}

	public static String getComboDeliveryCenterPlatformId(final String vendorId, final String vendorDeliveryCenterId,
			final String vendorComboId) {

		return platformIdEncoderDecoder.encodePlatformId(
				new ComboDeliveryCenterPlatformId(vendorId, vendorDeliveryCenterId, vendorComboId));
	}

	public static String decodeDeliveryCenterIdToVendorDeliveryCenterId(final String deliveryCenterId) {

		final DeliveryCenterPlatformId deliveryCenterPlatformId = (DeliveryCenterPlatformId) platformIdEncoderDecoder
				.decodePlatformId(deliveryCenterId, PlatformIdEnum.DELIVERY_CENTER);

		return deliveryCenterPlatformId.getVendorDeliveryCenterId();
	}

	public static String encodeEnforcement(final String vendorAccountId, final String vendorId, final String entity,
			final String entityId) {

		final PlatformIdEncoderDecoder platformIdEncoderDecoder = new PlatformIdEncoderDecoder();
		final EnforcementPlatformId enforcementPlatformId;

		if (StringUtils.isNotBlank(vendorAccountId)) {
			enforcementPlatformId = new EnforcementPlatformId(vendorId, vendorAccountId, entity, entityId);
		} else {
			enforcementPlatformId = new EnforcementPlatformId(vendorId, null, entity, entityId);
		}

		return platformIdEncoderDecoder.encodePlatformId(enforcementPlatformId);
	}

	public static String encodeItemId(final String vendorId, final String vendorItemId) {

		return platformIdEncoderDecoder.encodePlatformId(new ItemPlatformId(vendorId, vendorItemId));
	}

	public static String encodeDeliveryWindowId(final String vendorId, final String vendorDeliveryWindowId) {

		return platformIdEncoderDecoder.encodePlatformId(new DeliveryWindowPlatformId(vendorId, vendorDeliveryWindowId));
	}

	public static String encodeComboId(final String vendorId, final String vendorComboId) {

		return platformIdEncoderDecoder.encodePlatformId(new ComboPlatformId(vendorId, vendorComboId));
	}
}
