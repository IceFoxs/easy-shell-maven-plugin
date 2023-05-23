package com.github.icefoxs;

import cn.hutool.core.io.FileUtil;
import org.apache.commons.text.StringSubstitutor;
import org.apache.maven.plugin.AbstractMojo;
import org.apache.maven.plugin.MojoExecutionException;
import org.apache.maven.plugins.annotations.Mojo;
import org.apache.maven.plugins.annotations.Parameter;

import java.io.File;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

@Mojo(name = "easy-shell")
public class EasyShellMojo extends AbstractMojo {

    @Parameter(property = "project.build.directory")
    private File outputDirectory;

    @Parameter(property = "appName")
    private String appName;

    @Parameter(property = "appNameJar")
    private String appNameJar;

    @Parameter(property = "appIdentityId")
    private String appIdentityId;

    @Parameter(property = "startupShellName")
    private String startupShellName;

    @Parameter(property = "startupWinShellName")
    private String startupWinShellName;

    @Parameter(property = "shutdownShellName")
    private String shutdownShellName;


    public void execute() throws MojoExecutionException {
        Map<String, String> map = new ConcurrentHashMap<>();
        map.put("appName", appName);
        map.put("appNameJar", appNameJar);
        map.put("appIdentityId", appIdentityId);
        String startupShellText = FileUtil.readString(getClass().getClassLoader().getResource("startup.sh"), "UTF-8");
        getLog().info("EasyShellMojo outputDirectory" + outputDirectory.getAbsolutePath());
        getLog().info("EasyShellMojo startup.sh:" + StringSubstitutor.replace(startupShellText, map));
        FileUtil.mkdir(outputDirectory.getAbsolutePath());
        FileUtil.writeString(StringSubstitutor.replace(startupShellText, map),
                outputDirectory.getAbsolutePath() + FileUtil.FILE_SEPARATOR + startupShellName,
                "utf-8");
        String shutdownShellText = FileUtil.readString(getClass().getClassLoader().getResource("shutdown.sh"),
                "UTF-8");
        FileUtil.writeString(StringSubstitutor.replace(shutdownShellText, map),
                outputDirectory.getAbsolutePath() + FileUtil.FILE_SEPARATOR + shutdownShellName,
                "utf-8");
        String startupWinShellText = FileUtil.readString(getClass().getClassLoader().getResource("startup.bat"),
                "UTF-8");
        FileUtil.writeString(StringSubstitutor.replace(startupWinShellText, map),
                outputDirectory.getAbsolutePath() + FileUtil.FILE_SEPARATOR + startupWinShellName,
                "utf-8");

    }
}
