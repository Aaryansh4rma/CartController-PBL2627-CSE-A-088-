# Use the official Tomcat 9 server environment
FROM tomcat:9.0

# Clear out the default Tomcat homepage
RUN rm -rf /usr/local/tomcat/webapps/ROOT

# Copy your WAR file into Tomcat and rename it to ROOT.war 
# (Renaming it to ROOT.war ensures your app opens directly on the main URL)
COPY ShopAdmin.war /usr/local/tomcat/webapps/ROOT.war

# Expose the standard web port
EXPOSE 8080
