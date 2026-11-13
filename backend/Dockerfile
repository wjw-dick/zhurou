# ---------- 构建阶段 ----------
FROM maven:3.9-eclipse-temurin-17 AS build
WORKDIR /build

# 先拷贝 pom 以利用依赖缓存
COPY pom.xml ./
COPY zhushi-common/pom.xml zhushi-common/
COPY zhushi-system/pom.xml zhushi-system/
COPY zhushi-cms/pom.xml zhushi-cms/
COPY zhushi-store/pom.xml zhushi-store/
COPY zhushi-product/pom.xml zhushi-product/
COPY zhushi-reserve/pom.xml zhushi-reserve/
COPY zhushi-order/pom.xml zhushi-order/
COPY zhushi-member/pom.xml zhushi-member/
COPY zhushi-supplier/pom.xml zhushi-supplier/
COPY zhushi-channel/pom.xml zhushi-channel/
COPY zhushi-staff/pom.xml zhushi-staff/
COPY zhushi-pay/pom.xml zhushi-pay/
COPY zhushi-wechat/pom.xml zhushi-wechat/
COPY zhushi-oss/pom.xml zhushi-oss/
COPY zhushi-portal/pom.xml zhushi-portal/
COPY zhushi-admin/pom.xml zhushi-admin/
RUN mvn -B -q -DskipTests dependency:go-offline || true

COPY . .
RUN mvn -B clean package -DskipTests -q

# ---------- 运行阶段 ----------
FROM eclipse-temurin:17-jre
WORKDIR /app
ENV TZ=Asia/Shanghai
COPY --from=build /build/zhushi-admin/target/zhushi-admin.jar app.jar
EXPOSE 8090
ENTRYPOINT ["java", "-XX:+UseG1GC", "-Dfile.encoding=UTF-8", "-jar", "/app/app.jar"]
