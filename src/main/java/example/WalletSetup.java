package example;

import io.micronaut.context.event.BeanCreatedEvent;
import io.micronaut.context.event.BeanCreatedEventListener;
import io.micronaut.core.util.CollectionUtils;
import io.micronaut.jdbc.BasicJdbcConfiguration;
import org.apache.commons.io.FileUtils;

import javax.inject.Singleton;
import java.io.File;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.util.Map;

@Singleton
public class WalletSetup implements BeanCreatedEventListener<BasicJdbcConfiguration> {
    private final File walletDir = new File("/tmp", "demo-wallet");
    private final WalletConfig config;

    public WalletSetup(WalletConfig config) {
        this.config = config;
    }

    @Override
    public BasicJdbcConfiguration onCreated(BeanCreatedEvent<BasicJdbcConfiguration> event) {
        Map<String, Object> walletFiles = CollectionUtils.mapOf(
                "cwallet.sso",  config.getCwalletSso(),
                        "ewallet.p12",  config.getEwalletP12(),
                        "keystore.jks",  config.getKeystoreJks(),
                        "ojdbc.properties",  config.getOjdbcProperties(),
                        "sqlnet.ora",  config.getSqlnetOra(),
                        "tnsnames.ora",  config.getTnsnamesOra(),
                        "truststore.jks", config.getTruststoreJks()
        );

        if( !walletDir.exists() ) {
            createWallet(walletDir, walletFiles);
        }
        return event.getBean();
    }

    private void createWallet(File walletDir, Map<String, Object> walletFiles) {
        walletDir.mkdirs();
        for (String key : walletFiles.keySet()) {
            try {
                writeWalletFile(key, walletFiles.get(key));
            }
            catch (IOException e) {
                walletDir.delete();
                e.printStackTrace();
            }
        }
    }

    private void writeWalletFile(String key, Object value) {
        try {
            File walletFile = new File(walletDir + "/" + key);
            if(value instanceof String) {
                FileUtils.writeStringToFile(walletFile, (String) value, StandardCharsets.UTF_8);
            } else if (value instanceof byte[]) {
                FileUtils.writeByteArrayToFile(walletFile, (byte[]) value);
            }
            System.out.println("Stored wallet file: " + walletFile.getAbsolutePath());
        }
        catch (IOException e) {
            e.printStackTrace();
        }
    }
}