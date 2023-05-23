安装说明

```shell
mvn clean install
```

使用说明

```xml

<build>
    <plugins>
        <plugin>
            <groupId>com.github.icefoxs</groupId>
            <artifactId>easy-shell-maven-plugin</artifactId>
            <version>1.0-SNAPSHOT</version>
            <executions>
                <execution>
                    <id>package</id>
                    <phase>compile</phase>
                    <goals>
                        <goal>easy-shell</goal>
                    </goals>
                </execution>
            </executions>
            <configuration>
                <outputDirectory>${project.basedir}/src/main/resources</outputDirectory>
                <appName>xxxx</appName>
                <appNameJar>xxxxxxxxxxxx</appNameJar>
                <appIdentityId>xxxxxxxxxxxx</appIdentityId>
                <startupShellName>start.sh</startupShellName>
                <shutdownShellName>stop.sh</shutdownShellName>
                <startupWinShellName>start.bat</startupWinShellName>
            </configuration>
        </plugin>
    </plugins>
</build>
```