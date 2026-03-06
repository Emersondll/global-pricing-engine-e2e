package helpers;

public enum VendorEnum {

	// SIT Vendors
	DEFAULT_VENDOR_ID_SIT("25ead8c9-a15b-4394-b725-d62e18a2ea77", "sit", "56330460-8e75-4791-9f53-1693dc62f2eb",
			"4ab7a781-dc85-4d48-b074-63e0d26a83ca"),
	VENDOR_ID_2_SIT("42f582e0-eacb-49fe-95db-e35793615b2b", "sit", "57254642-a4c5-4f16-91e7-ad9632b66c33",
			"f6977605-a8dd-46b0-bdd0-dfc2b49afed1"),
	VENDOR_ID_AMBEV_SIT("58870cbc-7809-4e18-ba59-986b4992c842", "sit", "57254642-a4c5-4f16-91e7-ad9632b66c33",
			"57254642-a4c5-4f16-91e7-ad9632b66c33"),
	VENDOR_ID_BRF_SIT("13e5acaa-064c-4ff0-a616-ce3520d66ce5", "sit", "e511a659-782d-4414-91a2-e67022c79f76",
			"594f1f44-8c6a-4783-aa2a-9ebe99fe95d7"),
	VENDOR_ID_MERCASID_SIT("bb1d68ad-fafa-4e91-b64d-713c92e99db7", "sit", "d18ff62f-428b-49f7-9b40-e789dd0b6950",
			"af1ff82a-3553-4044-868b-517e29d2beae"),

	// UAT Vendors
	DEFAULT_VENDOR_ID_UAT("25ead8c9-a15b-4394-b725-d62e18a2ea77", "uat", "9d831a4f-5cdd-4875-997b-647cbc252d7d",
			"fd0b9881-16c9-42fb-af2b-d4cb20d43d71"),
	VENDOR_ID_2_UAT("42f582e0-eacb-49fe-95db-e35793615b2b", "uat", "70d2a6bb-7cf7-47c6-a985-0c4cd7f689cc",
			"9ecfb602-6bdf-4144-b5e1-d97e30d4f140"),
	VENDOR_ID_AMBEV_UAT("7a51f522-c3e3-421b-89d8-290d8eb2eddd", "uat", "e034fc5c-efbd-4da6-8b72-6845d0b25a5a",
			"d54bfbb5-9cf4-4a1b-b1dd-744706d401e2"),
	VENDOR_ID_BRF_UAT("3c5eece4-ac37-44e3-a95e-a264802a7dfe", "uat", "1716774f-4dd7-4dba-b63a-251a6d58e70c",
			"0222a56c-e563-4ad2-ab3c-bf32712431ee"),
	VENDOR_ID_MERCASID_UAT("2d741ecd-9e84-4107-aaed-a6f189528a07", "uat", "9596d0ad-a133-41e9-afbf-ff58cba321e8",
			"d919f5ff-a6a5-4d01-81a4-71bc3dc44d55"),
	VENDOR_ID_E2E_UAT_AR("29a9c869-e1b7-4011-9158-e2c53fed4d58", "uat", "87250aaf-a2ce-455e-a12e-9ad43018e3c7",
			"ea62bd15-8a07-42f8-8fd6-53de36d62e72"),
	VENDOR_ID_E2E_UAT_BB("f00dc091-fe6d-4d19-83bd-c74516d036bc", "uat", "4cd5328e-c141-4dd0-bab9-3415640fabea",
			"117e5565-5e48-402b-992f-3d8c43622a81"),
	VENDOR_ID_E2E_UAT_BO("06cbc1ce-abf3-4d9a-8f74-b98bd69c56b8", "uat", "f40b0408-6b63-42db-86c9-a3eeb6c037c3",
			"7fae5294-a10c-42db-a4b4-45f1d4155f81"),
	VENDOR_ID_E2E_UAT_BR("eafe490e-fddc-4b01-900a-d0dc45194ab6", "uat", "b83134f3-7927-4ada-95f3-633c89f87910",
			"1bd831e2-7404-421b-87a6-5b354b93503a"),
	VENDOR_ID_E2E_UAT_NESTLE_BR("d8e9fbc3-0678-4778-beb7-74165906d3fa", "uat", "6f886f93-0e5c-4ce1-b7e5-dfb6e7b3bbc8",
			"!rouHG_tJ%mkbG)a075g3=E8%US&vjn[dcYZ"),
	VENDOR_ID_E2E_UAT_NESTLE_EC("70b33632-6bce-4eeb-95a2-ba0be90bf908", "uat", "a2995323-d173-45ed-8c97-9f4b92e6ba7c",
			"gE#rLoiYZie0oPLiPYfHR[C=9M@b%YL)y!3W"),
	VENDOR_ID_E2E_UAT_CL("aefffd5f-edaf-4ffe-bec9-de6ae5ccd9d8", "uat", "573073dd-f787-413b-a5c9-9ebc07b9f710",
			"50314070-d999-4ed3-b200-6fdd5628c46f"),
	VENDOR_ID_E2E_UAT_CA("cbfe3f18-aa97-4fc7-8f72-ece748db2f06", "uat", "d582d068-e41d-44ea-81fb-f9ac3396ded4",
			"0a984521-dad1-490b-999e-9d853aa105bf"),
	VENDOR_ID_E2E_UAT_CO("9c2e5bbf-6960-470f-9bf3-698b131f0522", "uat", "3f3fd10c-4952-4b74-a771-aea742d4a19c",
			"452d5f8f-da1e-444f-b442-3a19ed1c6a4d"),
	VENDOR_ID_E2E_UAT_DO("63907b3e-3fb7-4f4c-b514-597c15c83042", "uat", "1f25dc4c-3be0-40ef-8b00-518521e5ef8c",
			"a35dacc6-a7eb-49e9-9519-f78fa24d07cf"),
	VENDOR_ID_E2E_UAT_EC("6b1c3a4d-5385-49fc-937c-eff4282b4388", "uat", "04b5b1d0-9350-4597-be38-5bdc5f7f7a8f",
			"93b960bb-f140-4c1d-aaf2-64e100b19a92"),
	VENDOR_ID_E2E_UAT_GB("a4fda951-f786-4acc-94b7-30f8373423fc", "uat", "848c9ee9-fef1-4213-a0c0-3380545a92c3",
			"2efee363-6d55-4c33-a565-8d7304bf22d2"),
	VENDOR_ID_E2E_UAT_HN("12621db3-cb1f-4a8d-9d93-5ef17058f8cf", "uat", "0e3c9a91-9e62-4169-9793-c90c390ec018",
			"44382413-83a5-4705-a53d-efc0ab88c043"),
	VENDOR_ID_E2E_UAT_B2B_HN("060ea43d-4a3d-4e47-b533-579e2f4e7b35", "uat", "9354859c-f81b-4b3b-8432-89ed7e5d3def",
			"3+b07(S4ESOA1==t9y6+98zyTMuBd[t#Z1JG"),
	VENDOR_ID_E2E_UAT_KR("5f64a920-a82e-49dc-94e4-d910bad19cac", "uat", "c132fd8b-73a5-456a-852b-5354f7cc1d45",
			"c8db2376-e56c-4eb3-b971-1f934600aab8"),
	VENDOR_ID_E2E_UAT_MX("7289d6e3-ea3b-4a23-904f-61e5b3e5c0b7", "uat", "743de2fe-0734-4a0d-a9e7-15b125439131",
			"996aba58-02cd-4f3a-8f3a-56bef76902a9"),
	VENDOR_ID_E2E_UAT_PA("7170d5c6-dcd6-4cf2-8a10-1b3b607bc438", "uat", "3b271728-1bf1-400f-a52a-cd6061cd2786",
			"311434a1-f6e4-462d-a9cc-2a01547dae4f"),
	VENDOR_ID_E2E_UAT_B2B_PA("c45d6e80-420c-4f57-ae77-2f5847b8ea29", "uat", "2976fd58-5368-44b4-aebd-c3ba2216978c",
			"sf)GHD?j9u!CTpV=J9xW?UHTqV0dF)2mYYy!"),
	VENDOR_ID_E2E_UAT_PE("badb25b3-f4be-4bf3-b635-910d6d62271e", "uat", "181d63ca-be26-4aba-97bb-37ffc6aa9bda",
			"05456dc0-e1cc-432d-acb5-194b355bf657"),
	VENDOR_ID_E2E_UAT_PY("29bb5c88-7732-41e3-bda4-568c872475e1", "uat", "a4067377-3529-479f-8e02-11685dd996e3",
			"70be44ae-a332-4afc-bd5e-9f6b3ff5e9d5"),
	VENDOR_ID_E2E_UAT_SV("77a738f3-2859-46f3-8760-6fcaf2d9b210", "uat", "3f76cc31-5aea-48cd-8da6-99f4a06ded3c",
			"53a7ab35-3612-4bff-9689-32fc1a686c02"),
	VENDOR_ID_E2E_UAT_TZ("2a8e7e9f-6492-4a4d-a5a9-6d78f1fa3d8a", "uat", "d210313a-7321-4c73-bd07-739f65bc59ff",
			"707cf336-8bb1-4dde-b3fc-986a11a92ae3"),
	VENDOR_ID_E2E_UAT_UG("1b60a7f7-0427-49d5-9ec5-144e27efd6e3", "uat", "8b038c17-8016-40eb-bf0a-98dd212b35e6",
			"22fa9c8f-1f23-43e8-9fd4-65f1daeb5d02"),
	VENDOR_ID_E2E_UAT_UY("e80556e0-e7e6-4966-9747-11ae13c672cb", "uat", "8350c8ab-e957-47ec-90d7-79a39d6d0e27",
			"0523f9f8-397b-47e4-8eed-3c642178cac8"),
	VENDOR_ID_E2E_UAT_ZA("dcc18843-a27c-46af-99b9-4b3dc15320aa", "uat", "bdd1a533-fae4-4c76-b0c7-71cffa15f18e",
			"c21fcefa-d278-4467-ae45-eb9fa5b38cc1");

	private final String vendorId;
	private final String environment;
	private final String clientId;
	private final String clientSecret;

	VendorEnum(final String vendorId, final String environment, String clientId, String clientSecret) {

		this.vendorId = vendorId;
		this.environment = environment;
		this.clientId = clientId;
		this.clientSecret = clientSecret;
	}

	public String getVendorId() {

		return vendorId;
	}

	public String getEnvironment() {

		return environment;
	}

	public String getClientId() {

		return clientId;
	}

	public String getClientSecret() {

		return clientSecret;
	}

	public static VendorEnum getVendor(final String vendorId, final String environment) {

		if (vendorId != null) {
			for (VendorEnum vendor : VendorEnum.values()) {

				if (vendorId.equalsIgnoreCase(vendor.vendorId) && environment.equalsIgnoreCase(vendor.environment)) {
					return vendor;
				}
			}
		}

		return environment.equalsIgnoreCase(DEFAULT_VENDOR_ID_UAT.environment) ? DEFAULT_VENDOR_ID_UAT : DEFAULT_VENDOR_ID_SIT;
	}
}
