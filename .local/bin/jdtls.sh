#!/usr/bin/env bash

#    -jar /usr/share/java/jdtls/plugins/org.eclipse.equinox.launcher_1.6.400.v20210924-0641.jar \

java \
	-Declipse.application=org.eclipse.jdt.ls.core.id1 \
	-Dosgi.bundles.defaultStartLevel=4 \
	-Declipse.product=org.eclipse.jdt.ls.core.product \
	-Dlog.level=ALL \
	-noverify \
	-Xmx1G \
    -jar /usr/share/java/jdtls/plugins/org.eclipse.equinox.launcher_*.jar \
    -configuration ~/.local/share/java/jdtls/config_linux \
	-data "$1" \
	--add-modules=ALL-SYSTEM \
	--add-opens java.base/java.util=ALL-UNNAMED \
	--add-opens java.base/java.lang=ALL-UNNAMED
