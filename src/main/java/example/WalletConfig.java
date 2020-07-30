package example;

import io.micronaut.context.annotation.ConfigurationProperties;

@ConfigurationProperties("wallet")
public class WalletConfig {
    private byte[] truststoreJks;
    private String tnsnamesOra;
    private String sqlnetOra;
    private String ojdbcProperties;
    private byte[] keystoreJks;
    private byte[] ewalletP12;
    private byte[] cwalletSso;


    public byte[] getTruststoreJks() {
        return truststoreJks;
    }

    public void setTruststoreJks(byte[] truststoreJks) {
        this.truststoreJks = truststoreJks;
    }

    public String getTnsnamesOra() {
        return tnsnamesOra;
    }

    public void setTnsnamesOra(String tnsnamesOra) {
        this.tnsnamesOra = tnsnamesOra;
    }

    public String getSqlnetOra() {
        return sqlnetOra;
    }

    public void setSqlnetOra(String sqlnetOra) {
        this.sqlnetOra = sqlnetOra;
    }

    public String getOjdbcProperties() {
        return ojdbcProperties;
    }

    public void setOjdbcProperties(String ojdbcProperties) {
        this.ojdbcProperties = ojdbcProperties;
    }

    public byte[] getKeystoreJks() {
        return keystoreJks;
    }

    public void setKeystoreJks(byte[] keystoreJks) {
        this.keystoreJks = keystoreJks;
    }

    public byte[] getEwalletP12() {
        return ewalletP12;
    }

    public void setEwalletP12(byte[] ewalletP12) {
        this.ewalletP12 = ewalletP12;
    }

    public byte[] getCwalletSso() {
        return cwalletSso;
    }

    public void setCwalletSso(byte[] cwalletSso) {
        this.cwalletSso = cwalletSso;
    }
}
