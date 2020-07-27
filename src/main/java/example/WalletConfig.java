package example;

import io.micronaut.context.annotation.ConfigurationProperties;

@ConfigurationProperties("wallet")
public class WalletConfig {
    private byte[] TRUSTSTORE_JKS;
    private String TNSNAMES_ORA;
    private String SQLNET_ORA;
    private String OJDBC_PROPERTIES;
    private byte[] KEYSTORE_JKS;
    private byte[] EWALLET_P12;
    private byte[] CWALLET_SSO;


    public byte[] getTRUSTSTORE_JKS() {
        return TRUSTSTORE_JKS;
    }

    public void setTRUSTSTORE_JKS(byte[] TRUSTSTORE_JKS) {
        this.TRUSTSTORE_JKS = TRUSTSTORE_JKS;
    }

    public String getTNSNAMES_ORA() {
        return TNSNAMES_ORA;
    }

    public void setTNSNAMES_ORA(String TNSNAMES_ORA) {
        this.TNSNAMES_ORA = TNSNAMES_ORA;
    }

    public String getSQLNET_ORA() {
        return SQLNET_ORA;
    }

    public void setSQLNET_ORA(String SQLNET_ORA) {
        this.SQLNET_ORA = SQLNET_ORA;
    }

    public String getOJDBC_PROPERTIES() {
        return OJDBC_PROPERTIES;
    }

    public void setOJDBC_PROPERTIES(String OJDBC_PROPERTIES) {
        this.OJDBC_PROPERTIES = OJDBC_PROPERTIES;
    }

    public byte[] getKEYSTORE_JKS() {
        return KEYSTORE_JKS;
    }

    public void setKEYSTORE_JKS(byte[] KEYSTORE_JKS) {
        this.KEYSTORE_JKS = KEYSTORE_JKS;
    }

    public byte[] getEWALLET_P12() {
        return EWALLET_P12;
    }

    public void setEWALLET_P12(byte[] EWALLET_P12) {
        this.EWALLET_P12 = EWALLET_P12;
    }

    public byte[] getCWALLET_SSO() {
        return CWALLET_SSO;
    }

    public void setCWALLET_SSO(byte[] CWALLET_SSO) {
        this.CWALLET_SSO = CWALLET_SSO;
    }
}
