# quickstart-cognizant-jupiter
1. Before executing Jupiter cloud formation template, download the war file and bootstrap scripts to an s3 location which is in the same region where CFT will be executed
2. As part of CFT parameters provide CIDR which can access the elastic beanstalk, else give 0.0.0.0/0
3. Once the required parameters are provided and CFT is executed successfully; from the output section get the Jupiter application URL.
4. Before accessing the application, the user should get the license key from Jupiter team by providing the access key available in the Jupiter landing page.
   
