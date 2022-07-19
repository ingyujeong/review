package kr.co.seoulit.account.posting.ledger.to;

public class AssetBean {
	private int assetNumber;
	private String assetName, assetCode;
	
	public int getAssetNumber() {
		return assetNumber;
	}
	public void setAssetNumber(int assetNumber) {
		this.assetNumber = assetNumber;
	}
	public String getAssetName() {
		return assetName;
	}
	public void setAssetName(String assetName) {
		this.assetName = assetName;
	}
	public String getAssetCode() {
		return assetCode;
	}
	public void setAssetCode(String assetCode) {
		this.assetCode = assetCode;
	}
}