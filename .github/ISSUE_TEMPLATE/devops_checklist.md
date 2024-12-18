---
name: DevOps Checklist
about: Create a checklist for production readiness.
---

# Production Readiness Checklist

An _issue template_ based on Gruntwork's [Production Readiness Checklist](https://gruntwork.io/devops-checklist/). This checklist is your guide to the best practices for deploying secure, scalable, and highly available infrastructure in AWS. Before you go live, go through each item, and make sure you haven't missed anything important!

## Server-side

- [ ] **Build AMIs**
      If you want to run your apps directly on EC2 Instances, you should package them as [Amazon Machine Images (AMIs)](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/AMIs.html) using a tool such as [Packer](https://www.packer.io/). Although we recommend Docker for all stateless apps (see below), we recommend directly using AMIs and EC2 Instances for all stateful apps, such as any data store (MySQL, MongoDB, Kafka), and app that writes to its local disk (e.g., WordPress, Jenkins).
- [ ] **Deploy AMIs using Auto Scaling Groups**
      The best way to deploy an AMI is typically to run it as an [Auto Scaling Group](https://docs.aws.amazon.com/autoscaling/ec2/userguide/AutoScalingGroup.html). This will allow you to spin up multiple EC2 Instances that run your AMI, scale the number of Instances up and down in response to load, and automatically replace failed Instances.
- [ ] **Build Docker images**
      If want to run your apps as containers, you should package your apps as [Docker](http://docker.com/) images and push those images to Amazon's [Elastic Container Registry (ECR)](https://aws.amazon.com/ecr/). We recommend Docker for all stateless apps and for local development (along with [Docker Compose](https://docs.docker.com/compose/)).
- [ ] **Deploy Docker images using ECS, EKS, or Fargate**
      You have several options for running Docker containers in AWS. One is to use the [Elastic Container Service (ECS)](https://aws.amazon.com/ecs/), where you run a cluster of EC2 Instances, and Amazon takes care of scheduling containers across them. Another is [Elastic Kubernetes Service (EKS)](https://aws.amazon.com/eks/), which is a Amazon's managed [Kubernetes](https://kubernetes.io/) (note, EKS is still in preview mode as of May, 2018). A third option is [AWS Fargate](https://aws.amazon.com/fargate/), a service where AWS manages and scales the underlying EC2 Instances for you and you just hand it Docker containers to run.
- [ ] **Deploy serverless apps using Lambda and API Gateway**
      If you want to build serverless apps, you should package them as [deployment packages](https://docs.aws.amazon.com/lambda/latest/dg/deployment-package-v2.html) for [AWS Lambda](https://aws.amazon.com/lambda/). You can expose your Lambda functions as HTTP endpoints using [API Gateway](https://aws.amazon.com/api-gateway/).
- [ ] **Configure CPU, memory, and GC settings**
      Configure CPU settings (e.g., ensure your app uses all available CPU cores using tools such as Node Cluster), memory settings (e.g., `-Xmx, -Xms` settings for the JVM), and GC settings (if applicable) for your app. If you're deploying directly on EC2 Instances, these should be configured based on the available CPU and memory on your EC2 Instance (see [Instance Types](https://aws.amazon.com/ec2/instance-types/)). If you are deploying Docker containers, then tell the scheduler the resources your app needs (e.g., in the [ECS Task Definition](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_definition_parameters.html)), and it will automatically try to find an EC2 Instance that has those resources.
- [ ] **Configure hard drives**
      Configure the [root volume](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/RootDeviceStorage.html) on each EC2 Instance with enough space for your app and log files. Note that root volumes are deleted when an Instance is terminated, so if you are running stateful apps that need to persist data between redeploys (or between crashes), attach one or more [EBS Volumes](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/EBSVolumes.html).

## Client-side

- [ ] **Pick a JavaScript framework**
      If you are building client-side applications in the browser, you may wish to use a JavaScript framework such as [React](https://reactjs.org/), [Angular](https://angular.io/), or [Ember](https://www.emberjs.com/). You'll need to update your build system to build and package the code appropriately (see [continuous integration](https://gruntwork.io/devops-checklist/#continuous-integration)).
- [ ] **Pick a compile-to-JS language**
      JavaScript has a number of problems and limitations, so you may wish to use a compile-to-JS language, such as [TypeScript](https://www.typescriptlang.org/), [Scala.js](https://www.scala-js.org/), [PureScript](https://github.com/paf31/purescript), [Elm](http://elm-lang.org/), or [ClojureScript](https://github.com/clojure/clojurescript). You'll need to update your build system to build and package the code appropriately (see [continuous integration](https://gruntwork.io/devops-checklist/#continuous-integration)).
- [ ] **Pick a compile-to-CSS language**
      CSS has a number of problems and limitations, so you may wish to use a compile-to-CSS language, such as [SASS](https://sass-lang.com/), [less](http://lesscss.org/), [cssnext](http://cssnext.io/), or [postcss](https://github.com/postcss/postcss). You'll need to update your build system to build and package the code appropriately (see [continuous integration](https://gruntwork.io/devops-checklist/#continuous-integration)).
- [ ] **Optimize your assets**
      All CSS and JavaScript should be minified and all images should be compressed. You may wish to concatenate your CSS and JavaScript files and [sprite images](https://css-tricks.com/css-sprites/) to reduce the number of requests the browser has to make. Make sure to enable gzip compression. Much of this can be done using a build system such as [Grunt](https://gruntjs.com/), [Gulp](https://gulpjs.com/), [Broccoli](https://github.com/broccolijs/broccoli), or [webpack](https://webpack.js.org/).
- [ ] **Use a static content server**
      You should serve all your static content (CSS, JS, images, fonts) from a static content server so that your dynamic web framework (e.g., from Rails, Node.js, or Django) can focus solely on processing dynamic requests. The best static content host to use with AWS is [S3](https://aws.amazon.com/s3/).
- [ ] **Use a CDN**
      Use [CloudFront](https://aws.amazon.com/cloudfront/) as a [Content Distribution Network (CDN)](https://en.wikipedia.org/wiki/Content_delivery_network) to cache and distribute your content across servers all over the world. This significantly reduces latency for users and is especially effective for static content.
- [ ] **Configure caching**
      Think carefully about versioning, caching, and cache-busting for your static content. One option is to put the version number of each release directly in the URL (e.g., `/static/v3/foo.js`), which is easy to implement, but means 100% of your content is "cache busted" each release. Another option is "asset fingerprinting," where the build system renames each static content file with a hash of that files contents (e.g., `foo.js` becomes `908e25f4bf641868d8683022a5b62f54.js`), which is more complicated to implement (note: many build systems have built-in support), but ensures that only content that has changed is ever cache busted.

## Data storage

- [ ] **Deploy relational databases**
      Use Amazon's [Relational Database Service (RDS)](https://aws.amazon.com/rds/) to run MySQL, PostgreSQL, Oracle, SQL Server, or MariaDB. Consider [Amazon Aurora](https://aws.amazon.com/rds/aurora/) as a highly scalable, cloud-native, MySQL and PostgreSQL compatible database. Both RDS and Aurora support automatic failover, read replicas, and automated backup.
- [ ] **Deploy NoSQL databases**
      Use [Elasticache](https://aws.amazon.com/elasticache/) if you want to use Redis or Memcached for in-memory key-value storage (Redis provides persistence too, but it's typically only recommended for ephemeral data). Use [DynamoDB](https://aws.amazon.com/dynamodb/) if you need a managed, eventually consistent, persistent key-value store. Use [DocumentDB](https://aws.amazon.com/documentdb/) if you need a managed, scalable document store that is compatible with MongoDB (albeit, with a [number of limitations and differences](https://www.mongodb.com/atlas-vs-amazon-documentdb)). If you need other NoSQL databases, such as MongoDB, Couchbase, or InfluxDB, you'll need to look to other managed services (e.g., [mLab](https://mlab.com/)) or you can run them yourself (see the [Gruntwork Library](https://gruntwork.io/infrastructure-as-code-library/)).
- [ ] **Deploy queues**
      Use [Amazon Simple Queue Service (SQS)](https://aws.amazon.com/sqs/) as a managed, distributed queue.
- [ ] **Deploy search tools**
      Use [Amazon Elasticsearch](https://aws.amazon.com/elasticsearch-service/) or [CloudWatch Logs Insights](https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/AnalyzingLogData.html) for log analysis and full text search. Note that Amazon Elasticsearch has some [significant limitations](https://code972.com/blog/2017/12/111-why-you-shouldnt-use-aws-elasticsearch-service), so if you need to work around those, you'll need to run the ELK stack yourself (see the [Gruntwork Library](https://gruntwork.io/infrastructure-as-code-library/)).
- [ ] **Deploy stream processing tools**
      Use [Amazon Managed Streaming for Apache Kafka (MSK)](https://aws.amazon.com/msk/) or [Amazon Kinesis](https://aws.amazon.com/kinesis/) to process streaming data. Note that Kinesis has some [significant limitations](https://docs.aws.amazon.com/streams/latest/dev/service-sizes-and-limits.html), and [MSK has some smaller limitations](https://docs.aws.amazon.com/msk/latest/developerguide/limits.html), so if you need to work around those, you can look to other managed services (e.g., [Confluent Cloud](https://www.confluent.io/confluent-cloud/)) or you can run [Kafka](https://kafka.apache.org/) yourself (see the [Gruntwork Library](https://gruntwork.io/infrastructure-as-code-library/)).
- [ ] **Deploy a data warehouse**
      Use [Amazon Redshift](https://aws.amazon.com/redshift/) for data warehousing.
- [ ] **Deploy big data systems**
      Use [Amazon EMR](https://aws.amazon.com/emr/) to run Hadoop, Spark, HBase, Presto, and Hive.
- [ ] **Set up cron jobs**
      Use [AWS Lambda Scheduled Events](https://docs.aws.amazon.com/lambda/latest/dg/with-scheduled-events.html) or [ECS Scheduled Tasks](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/scheduled_tasks.html) to reliably run background jobs on a schedule (cron jobs). Look into [AWS Step Functions](https://aws.amazon.com/step-functions/) to build reliable, multi-step, distributed workflows.
- [ ] **Configure disk space**
      Configure enough disk space on your system for all the data you plan to store. If you are running a data storage system yourself, you'll probably want to store the data on one or more [EBS Volumes](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/EBSVolumes.html) that can be attached and detached as Instances are replaced. Note: using EBS Volumes with Auto Scaling Groups (ASGs) is very tricky, as ASGs can launch an Instance in any Availability Zone, but an EBS Volume can only be attached from the same Availability Zone (see the [Gruntwork Library](https://gruntwork.io/infrastructure-as-code-library/) for solutions).
- [ ] **Configure backup**
      Configure backup for all of your data stores. Most Amazon-managed data stores, such as RDS and Elasticache, support automated nightly snapshots. For backing up EC2 Instances and EBS Volumes, consider running [ec2-snapper](https://github.com/josh-padnick/ec2-snapper) on a scheduled basis.
- [ ] **Configure cross-account backup**
      Copy all of your backups to a separate AWS account for extra redundancy. This ensures that if a disaster happens in one AWS account—e.g., an attacker gets in or someone accidentally deletes all the backups—you still have a copy of your data available elsewhere.
- [ ] **Test your backups**
      If you never test your backups, they probably don't work. Create automated tests that periodically restore from your backups to check they are actually working.
- [ ] **Set up schema management**
      For data stores that use a schema, such as relational databases, define the schema in schema migration files, check those files into version control, and apply the migrations as part of the deployment process. See [Flyway](https://flywaydb.org/) and [Liquibase](https://www.liquibase.org/).

## Scalability and High Availability

- [ ] **Choose between a Monolith and Microservices**
      Ignore the hype and stick with a monolithic architecture as long as you possibly can. Microservices have massive costs (operational overhead, performance overhead, more failure modes, loss of transactions/atomicity/consistency, difficulty in making global changes, backwards compatibility requirements), so only use them when your company grows large enough that you can't live without one of the benefits they provide (support for different technologies, support for teams working more independently from each other). See [Don't Build a Distributed Monolith](https://www.youtube.com/watch?v=-czp0Y4Z36Y), [Microservices — please, don't](https://blog.rapid7.com/2016/09/15/microservices-please-dont/), and [Microservice trade-offs](https://martinfowler.com/articles/microservice-trade-offs.html) for more info.
- [ ] **Configure service discovery**
      If you do go with microservices, one of the problems you'll need to solve is how services can discover the IPs and ports of other services they depend on. Some of the solutions you can use include [Load Balancers](https://aws.amazon.com/elasticloadbalancing/), [ECS Service Discovery](https://aws.amazon.com/blogs/aws/amazon-ecs-service-discovery/), and [Consul](https://www.consul.io/).
- [ ] **Use multiple Instances**
      Always run more than one copy (i.e., more than one EC2 Instance or Docker container) of each stateless application. This allows you to tolerate the app crashing, allows you to scale the number of copies up and down in response to load, and makes it possible to do zero-downtime deployments.
- [ ] **Use multiple Availability Zones**
      Configure your [Auto Scaling Groups](https://docs.aws.amazon.com/autoscaling/ec2/userguide/AutoScalingGroup.html) and [Load Balancers](https://aws.amazon.com/elasticloadbalancing/) to make use of multiple [Availability Zones (AZs)](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-regions-availability-zones.html) (3 is recommended) in your AWS account so you can tolerate the failure of an entire AZ.
- [ ] **Set up load balancing**
      Distribute load across your apps and Availability Zones using Amazon's managed [Load Balancers](https://aws.amazon.com/elasticloadbalancing/), which are designed for high availability and scalability. Use the [Application Load Balancer (ALB)](https://docs.aws.amazon.com/elasticloadbalancing/latest/application/introduction.html) for all HTTP/HTTPS traffic and the [Network Load Balancer (NLB)](https://docs.aws.amazon.com/elasticloadbalancing/latest/network/introduction.html) for everything else.
- [ ] **Use Auto Scaling**
      Use [auto scaling](https://aws.amazon.com/autoscaling/) to automatically scale the number of resources you're using up to handle higher load and down to save money when load is lower.
- [ ] **Configure Auto Recovery**
      Configure a process supervisor such as [systemd](https://github.com/systemd/systemd) or [supervisord](http://supervisord.org/) to automatically restart failed processes. Configure your [Auto Scaling Groups](https://docs.aws.amazon.com/autoscaling/ec2/userguide/AutoScalingGroup.html) to use a [Load Balancer](https://aws.amazon.com/elasticloadbalancing/) for health checks and to automatically replace failed EC2 Instances. Use your Docker orchestration tool to monitor the health of your Docker containers and automatically restart failed ones (e.g., [ECS Health Checks](https://docs.aws.amazon.com/AmazonECS/latest/APIReference/API_HealthCheck.html)).
- [ ] **Configure graceful degradation**
      Handle failures in your dependencies (e.g., a service not responding) by using [graceful degradation patterns](https://twitter.com/copyconstruct/status/994138694582812672), such as retries (with exponential backoff and jitter), circuit breaking, timeouts, deadlines, and rate limiting.
- [ ] **Perform load tests and use chaos engineering**
      Run load tests against your infrastructure to figure out when it falls over and what the bottlenecks are. Use [chaos engineering](https://principlesofchaos.org/) to continuously test the resilience of your infrastructure (see also [chaos monkey](https://github.com/Netflix/chaosmonkey)).

## Continuous Integration

- [ ] **Pick a Version Control System**
      Check all code into a Version Control System (VCS). The most popular choice these days is [Git](https://git-scm.com/). You can use [GitHub](https://github.com/), [GitLab](https://gitlab.com/), or [BitBucket](https://bitbucket.org/) to host your Git repo.
- [ ] **Do code reviews**
      Set up a code review process in your team to ensure all commits are reviewed. [Pull requests](https://help.github.com/articles/about-pull-requests/) are an easy way to do this.
- [ ] **Configure a build system**
      Set up a build system for your project, such as [Gradle](https://gradle.org/) (for Java), [Rake](https://github.com/ruby/rake) (for Ruby), or [Yarn](https://yarnpkg.com/en/) (for Node.js). The build system is responsible for compiling your app, as well as many other tasks described below.
- [ ] **Use dependency management**
      Your build systems should allow you to explicitly define all the of the dependencies for your apps. Each dependency should be versioned, and ideally, the versions of all dependencies, including transitive dependencies, are captured in a lock file (e.g., read about [Yarn's lock file](https://yarnpkg.com/lang/en/docs/yarn-lock/) and [Go's dep lock file](https://github.com/golang/dep/blob/master/docs/FAQ.md#what-is-the-difference-between-gopkgtoml-the-manifest-and-gopkglock-the-lock).
- [ ] **Configure static analysis**
      Configure your build system so it can run [static analysis tools](https://en.wikipedia.org/wiki/List_of_tools_for_static_code_analysis) on your code, such as linters and code coverage.
- [ ] **Set up automatic code formatting**
      Configure your build system to automatically format the code according to a well-defined style (e.g., with Go, you can run `go fmt`; with Terraform, you can run `terraform fmt`). This way, all your code has a consistent style, and your team doesn't have to spend any time arguing about tabs vs spaces or curly brace placement.
- [ ] **Set up automated tests**
      Configure your build system so it can run automated tests on your code, with tools such as [JUnit](https://junit.org/junit5/) (for Java), [RSpec](http://rspec.info/) (for Ruby), or [Mocha](https://mochajs.org/) (for Node.js).
- [ ] **Publish versioned artifacts**
      Configure your build system so it can package your app into a deployable "artifact," such as an AMI or Docker image. Each artifact should be immutable and have a unique version number that makes it easy to figure out where it came from (e.g., tag Docker images with the Git commit ID). Push the artifact to an artifact repository (e.g., ECR for Docker images) form which it can be deployed.
- [ ] **Set up a build server**
      Set up a server to automatically run builds, static analysis, automated tests, etc. after every commit. You can use a hosted system such as  [CircleCI](https://circleci.com/)  or  [Travis CI](https://travis-ci.org/), or run your a build server yourself with a tool such as  [Jenkins](https://jenkins.io/).

## Continuous Delivery

- [ ] **Create deployment environments**
      Define separate "environments" such as dev, stage, and prod. Each environment can either be a separate AWS account (recommended for larger teams and security-sensitive and compliance use cases) or a separate VPC within a single AWS account (recommended only for smaller teams).
- [ ] **Set up per-environment configuration**
      Your apps may need different configuration settings in each environment: e.g., different memory settings, different features on or off. Define these in config files that get checked into version control (e.g., dev-config.yml, stage-config.yml, prod-config.yml) and packaged with your app artifact (i.e., packaged directly into the Docker image for your app), and have your app boot up code pick the proper config file for the current environment during boot.
- [ ] **Define your infrastructure as code**
      Do not deploy anything by hand, by using the AWS Console, or the AWS CLI. Instead, define all of your  [infrastructure as code](https://blog.gruntwork.io/a-comprehensive-guide-to-terraform-b3d32832baca)  using tools such as  [Terraform](https://www.terraform.io/),  [Packer](https://www.packer.io/), and  [Docker](https://www.docker.com/).
- [ ] **Test your infrastructure code**
      If all of your infrastructure is defined as code, you can create automated tests for it. The goal is to verify your infrastructure works as expected after every single commit, long before those infrastructure changes affect prod. See  [Terratest](https://github.com/gruntwork-io/terratest)  for more info.
- [ ] **Set up immutable infrastructure**
      Don't update EC2 Instance or Docker containers in place. Instead, launch completely new EC2 Instances and new Docker containers and, once those are up and healthy, remove the old EC2 Instances and Docker images. Since we never "modify" anything, but simply replace, this is known as  [immutable infrastructure](https://www.oreilly.com/ideas/an-introduction-to-immutable-infrastructure), and it makes it easier to reason about what's deployed and to manage that infrastructure.
- [ ] **Promote artifacts**
      Deploy immutable artifacts to one environment at a time, and promote it to the next environment after testing. For example, you might deploy v0.3.2 to dev, and test it there. If it works well, you promote the exact same artifact, v0.3.2, to stage, and test it there. If all goes well, you finally promote v0.3.2 to prod. Since it's the exact same code in every environment, there's a good chance that if it works in one environment, it'll also work in the others.
- [ ] **Roll back in case of failure**
      If you use immutable, versioned artifacts as your unit of deployment, then any time something goes wrong, you have the option to roll back to a known-good state by deploying a previous version. If your infrastructure is defined as code, you can also see what changed between versions by looking at the diffs in version control.
- [ ] **Automate your deployments**
      One of the advantages of defining your entire infrastructure as code is that you can fully automate the deployment process, making deployments faster, more reliable, and less stressful.
- [ ] **Do zero-downtime deployments**
      There are several strategies you can use for Zero-downtime deployments, such as [blue-green deployment](https://martinfowler.com/bliki/BlueGreenDeployment.html) (works best for stateless apps) or [rolling deployment](http://hintcafe.net/post/56948449558/rolling-deployment-with-no-downtime) (works best for stateful apps).
- [ ] **Use canary deployments**
      Instead of deploying the new version of your code to all servers, and risking a bug affecting all users at once, you limit the possible damage by first deploying te new code to a single "canary" server. You then compare the canary to a "control" server running the old code and make sure there are no unexpected errors, performance issues, or other problems. If the canary looks healthy, roll out the new version of your code to the rest of the servers. If not, roll back the canary.
- [ ] **Use feature toggles**
      Wrap all new functionality in an if-statement that only evaluates to true if a the [feature toggle](https://martinfowler.com/articles/feature-toggles.html) is enabled. By default, all feature toggles are disabled, so you can safely check in and even deploy code that isn't completely finished (as long as it compiles!), and it won't affect any user. When the feature is done, you can use a UI to gradually enable the feature toggle for specific users: e.g., initially just for your company's employees, then for 1% of all users, then 10% of all users, and so on. At any stage, if anything goes wrong, you can turn the feature toggle off again. Feature toggles allow you to separate _deployment_ of new code from the _release_ of new features in that code. They also allow you to do [bucket testing](https://en.wikipedia.org/wiki/A/B_testing). See [LaunchDarkly](https://launchdarkly.com/), [Split](https://www.split.io/), and [Optimizely](https://www.optimizely.com/) for more info.

## Networking

- [ ] **Set up VPCs**
      Don't use the Default VPC, as everything in it is publicly accessible by default. Instead, create one or more custom  [Virtual Private Clouds (VPC)](https://aws.amazon.com/vpc/), each with their own IP address range (see  [VPC and subnet sizing](https://docs.aws.amazon.com/AmazonVPC/latest/UserGuide/VPC_Subnets.html#VPC_Sizing)), and deploy all of your apps into those VPCs.
- [ ] **Set up subnets**
      Create three "tiers" of [subnets](https://docs.aws.amazon.com/AmazonVPC/latest/UserGuide/VPC_Subnets.html) in each VPC: public, private-app, private-persistence. The public subnets are directly accessible from the public Internet and should only be used for a small number of highly locked down, user-facing services, such as load balancers and Bastion Hosts. The private-apps subnets are only accessible from within the VPC from the public subnets and should be used to run your apps (Auto Scaling Groups, Docker containers, etc.). The private-persistence subnets are also only accessible from within the VPC from the private-app subnets (but NOT the public subnets) and should be used to run all your data stores (RDS, ElastiCache, etc.). See [A Reference VPC Architecture](https://www.whaletech.co/2014/10/02/reference-vpc-architecture.html).
- [ ] **Configure Network ACLs**
      Create [Network Access Control Lists (NACLs)](https://docs.aws.amazon.com/AmazonVPC/latest/UserGuide/VPC_ACLs.html) to control what traffic can go between different subnets. We recommend allowing the public subnets to receive traffic from anywhere, the private-app subnets to only receive traffic from the public subnets, and the private-persistence subnets to only receive traffic from the private-app subnets.
- [ ] **Configure Security Groups**
      Every AWS resource (e.g., EC2 Instances, Load Balancers, RDS DBs, etc.) has a [Security Group](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-network-security.html) that acts as a firewall, controlling what traffic is allowed in and out of that resource. By default, no traffic is allowed in or out. Follow the [Principle of Least Privilege](https://en.wikipedia.org/wiki/Principle_of_least_privilege) and open up the absolute minimum number of ports you can for each resource. When opening up a port, you can also specify either the CIDR block (IP address range) or ID of another Security Group that is allowed to access that port. Reduce these to solely trusted servers where possible. For example, EC2 Instances should only allow SSH access (port 22) from the Security Group of a single, locked-down, trusted server (the [Bastion Host](https://en.wikipedia.org/wiki/Bastion_host)).
- [ ] **Configure Static IPs**
      By default, all AWS resources (e.g., EC2 Instances, Load Balancers, RDS DBs, etc.) have dynamic IP addresses that could change over time (e.g., after a redeploy). When possible, use [Service Discovery](https://gruntwork.io/devops-checklist/#scalability-and-high-availability) to find the IPs of services you depend on. If that's not possible, you can create static IP addresses that can be attached and detached from resources using [Elastic IP Addresses (EIPs)](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/elastic-ip-addresses-eip.html) for public IPs or [Elastic Network Interfaces (ENIs)](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-eni.html) for private IPs.
- [ ] **Configure DNS using Route 53**
      Manage DNS entries using [Route 53](https://aws.amazon.com/route53/). You can buy public domain names using the [Route 53 Registrar](https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/registrar.html) or create custom private domain names, accessible only from within your VPC, using [Route 53 Private Hosted Zones](https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/hosted-zones-private.html).

## Security

- [ ] **Configure encryption in transit**
      Encrypt all network connections using [TLS](https://en.wikipedia.org/wiki/Transport_Layer_Security). Many AWS services support TLS connections by default (e.g., RDS) or if you enable them (e.g., ElastiCache). You can get free, auto-renewing TLS certificates for your public domain names from [AWS Certificate Manager (ACM)](https://aws.amazon.com/certificate-manager/). You can also use the [ACM Private Certificate Authority](https://aws.amazon.com/certificate-manager/private-certificate-authority/) to get auto-renewing TLS certificates for private domain names within your VPC.
- [ ] **Configure encryption at rest**
      Encrypt the root volume of each EC2 Instance by using the [encrypt_boot](https://www.packer.io/docs/builders/amazon-ebs.html#encrypt_boot) setting in Packer. Enable encryption for each [EBS Volume](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/EBSEncryption.html) too. Many AWS services optionally support disk encryption: e.g., see [Encrypting Amazon RDS Resources](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Overview.Encryption.html) and [ElastiCache for Redis At-Rest Encryption](https://docs.aws.amazon.com/AmazonElastiCache/latest/red-ug/at-rest-encryption.html).
- [ ] **Set up SSH access**
      Do NOT share [EC2 KeyPairs](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html) with your team! Otherwise, everyone will be using the same username and key for server access (so there's no audit trail), the key may easily be compromised, and if it is, or someone leaves the company, you'll have to redeploy ALL your EC2 Instances to change the KeyPair. Instead, configure your EC2 Instances so that each developer can use their own username and SSH key, and if that developer leaves the company, the key can be invalidated immediately (see the [Gruntwork Library](https://gruntwork.io/infrastructure-as-code-library/) for solutions).
- [ ] **Deploy a Bastion Host**
      Just about all your EC2 Instances should be in private subnets and NOT accessible directly from the public Internet. Only a single, locked-down EC2 Instance, known as the Bastion Host, should run in the public subnets. You must first connect to the Bastion Host, which gets you "in" to the network, and then you can use it as a "jump host" to connect to the other EC2 Instances. The only other EC2 instances you might want to run in public subnets are those that must be accessible directly from the public Internet, such as load balancers (though in most cases, we recommend using Amazon-managed [Load Balancers](https://aws.amazon.com/elasticloadbalancing/)).
- [ ] **Deploy a VPN Server**
      We typically recommend running a VPN Server as the entry point to your network (as the Bastion Host). [OpenVPN](https://openvpn.net/) is the most popular option for running a VPN server.
- [ ] **Set up a secrets management solution**
      NEVER store secrets in plaintext. Developers should store their secrets in a secure secrets manager, such as [pass](https://www.passwordstore.org/), [1Password](https://1password.com/), or [LastPass](https://www.lastpass.com/). Applications should store all their secrets (such as DB passwords and API keys) either in files encrypted with [KMS](https://aws.amazon.com/kms/) or in a secret store such as [AWS Secrets Manager](https://aws.amazon.com/secrets-manager/), [SSM Parameter Store](https://docs.aws.amazon.com/systems-manager/latest/userguide/systems-manager-parameter-store.html), or [HashiCorp Vault](https://www.vaultproject.io/).
- [ ] **Use server hardening practices**
      Every server should be hardened to protect against attackers. This may include: running [CIS Hardened Images](https://www.cisecurity.org/services/hardened-virtual-images/), [fail2ban](https://www.fail2ban.org/wiki/index.php/Main_Page) to protect against malicious access, [unattended upgrades](https://help.ubuntu.com/community/AutomaticSecurityUpdates) to automatically install critical security patches, [firewall software](https://en.wikipedia.org/wiki/Firewall_(computing)), [anti-virus software](https://en.wikipedia.org/wiki/Antivirus_software), and [file integrity monitoring software](https://en.wikipedia.org/wiki/File_integrity_monitoring). See also [My First 10 Minutes On a Server](https://www.codelitt.com/blog/my-first-10-minutes-on-a-server-primer-for-securing-ubuntu/) and [Guide to User Data Security](https://www.inversoft.com/guides/2016-guide-to-user-data-security).
- [ ] **Go through the OWASP Top 10**
      Browse through the [Top 10 Application Security Risks](https://www.owasp.org/index.php/Top_10-2017_Top_10) list from the [Open Web Application Security Project (OWASP)](https://www.owasp.org/index.php/Main_Page) and check your app for vulnerabilities such as injection attacks, CSRF, and XSS.
- [ ] **Go through a security audit**
      Have a third party security service perform a security audit and do penetration testing on your services. Fix any issues they uncover.
- [ ] **Sign up for security advisories**
      Join the security advisory mailing lists for any software you use and monitor those lists for announcements of critical security vulnerabilities.
- [ ] **Create IAM Users**
      Create an [IAM User](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_users_create.html) for each developer. The developer will have a web console login for accessing AWS from a web browser and a set of API keys for accessing AWS from the CLI. Note that the [root user](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_root-user.html) on your AWS account should only be used to create an initial admin IAM User; after that, do all your work from that IAM user account and never use the root user account again!
- [ ] **Create IAM Groups**
      Manage permissions for IAM users using [IAM Groups](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_groups.html). Follow the [Principle of Least Privilege](https://en.wikipedia.org/wiki/Principle_of_least_privilege), assigning the minimum permissions possible to each IAM Group and User.
- [ ] **Create IAM Roles**
      Give your AWS resources (e.g., EC2 Instances, Lambda Functions) access to other resources by attaching [IAM Roles](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles.html). All AWS SDK and CLI tools automatically know how to use IAM Roles, so you should never have to copy AWS access keys to a server.
- [ ] **Create cross-account IAM Roles**
      If you are using multiple AWS accounts (e.g., one for dev and one for prod), you should define all of the IAM Users in one account, and use [IAM Roles](https://docs.aws.amazon.com/IAM/latest/UserGuide/tutorial_cross-account-with-roles.html) to provide access to the other AWS accounts. This way, developers have only one set of credentials to manage, and you can have very fine-grained permissions control over what IAM Users can do in any given account.
- [ ] **Create a password policy and enforce MFA**
      Set a [password policy](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_passwords_account-policy.html) that requires a long password for all IAM users and require every user to enable [Multi-Factor Authentication (MFA)](https://aws.amazon.com/iam/details/mfa/).
- [ ] **Record audit Logs**
      Enable [CloudTrail](https://aws.amazon.com/cloudtrail/) to maintain an audit log of all changes happening in your AWS account.

## Monitoring

- [ ] **Track availability metrics**
      The most basic set of metrics: can a user access your product or not? Useful tools:  [Route 53 Health Checks](https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/dns-failover.html)  and  [Pingdom](https://www.pingdom.com/).
- [ ] **Track business metrics**
      Metrics around what users are doing with your product, such as what pages they are viewing, what items they are buying, and so on. Useful tools: [Google Analytics](https://www.google.com/analytics), [Kissmetrics](https://www.kissmetrics.com/), and [Mixpanel](https://mixpanel.com/).
- [ ] **Track application metrics**
      Metrics around what your application is doing, such as QPS, latency, and throughput. Useful tools:  [CloudWatch](https://aws.amazon.com/cloudwatch/),  [DataDog](https://www.datadoghq.com/), and  [New Relic](https://newrelic.com/).
- [ ] **Track server metrics**
      Metrics around what your hardware is doing, such as CPU, memory, and disk usage. Useful tools:  [CloudWatch](https://aws.amazon.com/cloudwatch/),  [DataDog](https://www.datadoghq.com/),  [New Relic](https://newrelic.com/),  [Nagios](https://www.nagios.org/),  [Icinga](https://www.icinga.com/), and  [collectd](https://collectd.org/).
- [ ] **Configure services for observability**
      Record events and stream data from all services. Slice and dice it using tools such as  [Kafka](https://kafka.apache.org/)  and  [KSQL](https://www.confluent.io/product/ksql/),  [Honeycomb](https://honeycomb.io/), and  [OpenTracing](http://opentracing.io/).
- [ ] **Store logs**
      To prevent log files from taking up too much disk space, configure log rotation on every server using a tool such as  [logrotate](https://linux.die.net/man/8/logrotate). To be able to view and search all log data from a central location (i.e., a web UI), set up log aggregation using tools such as  [CloudWatch Logs](https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/WhatIsCloudWatchLogs.html),  [Filebeat](https://www.elastic.co/products/beats/filebeat),  [Logstash](https://www.elastic.co/products/logstash),  [Loggly](https://www.loggly.com/), and  [Papertrail](https://papertrailapp.com/).
- [ ] **Set up alerts**
      Configure alerts when critical metrics cross pre-defined thresholds, such as CPU usage getting too high or available disk space getting too low. Most of the metrics and log tools listed earlier in this section support alerting. Set up an on-call rotation using tools such as [PagerDuty](https://www.pagerduty.com/) and [VictorOps](https://victorops.com/).

## Cost optimization

- [ ] **Pick proper EC2 Instance types and sizes**
      AWS offers a number of different  [Instance Types](https://aws.amazon.com/ec2/instance-types/), each optimized for different purposes: compute, memory, storage, GPU, etc. Use  [EC2Instances.info](https://www.ec2instances.info/)  to slice and dice the different Instance Types across a variety of parameters. Try out a variety of Instance sizes by load testing your app on each type and picking the best balance of performance and cost. In general, running a larger number of smaller Instances ("horizontal scaling") is going to be cheaper, more performant, and more reliable than a smaller number of larger Instances ("vertical scaling"). See also  [How Netflix Tunes EC2 Instances for Performance](https://www.slideshare.net/brendangregg/how-netflix-tunes-ec2-instances-for-performance).
- [ ] **Use Spot EC2 Instances for background jobs**
      [EC2 Spot Instances](https://aws.amazon.com/ec2/spot/)  allow you to "bid" a much lower price for EC2 Instances than what you'd pay on-demand (as much as 90% lower!), and when there is capacity to fulfill your request, AWS will give you the EC2 Instances at that price. Note that if AWS needs to reclaim that capacity, it may terminate the EC2 Instance at any time with a 2-minute notice. This makes Spot Instances a great way to save money on any workload that is non-urgent (e.g., all background jobs, machine learning, image processing) and pre-production environments (e.g., run an ECS cluster on spot instances by just setting a single extra param!).
- [ ] **Use Reserved EC2 Instances for dedicated work**
      [EC2 Reserved Instances](https://aws.amazon.com/ec2/pricing/reserved-instances/)  allow you to reserve capacity ahead of time in exchange for a significant discount (up to 75%) over on-demand pricing. This makes Reserved Instances a great way to save money when you know for sure that you are going to be using a certain number of Instances consistently for a long time period. For example, if you knew you were going to run a 3-node ZooKeeper cluster all year long, you could reserve three `r4.large` Instances for one year, at a discount of 75%. Reserved Instances are a billing optimization, so no code changes are required: just reserve the Instance Type, and next time you use it, AWS will charge you less for it.
- [ ] **Shut down EC2 Instances and RDS DBs when not using them**
      You can shut down (but not terminate!) EC2 Instances and RDS DBs when you're not using them, such as in your pre-prod environments at night and on weekends. You could even create a Lambda function that does this on a regular schedule. For more info, see  [AWS Instance Scheduler](https://aws.amazon.com/answers/infrastructure-management/instance-scheduler/).
- [ ] **Use Auto Scaling**
      Use  [Auto Scaling](https://aws.amazon.com/autoscaling/)  to increase the number of EC2 Instances when load is high and then to decrease it again—and thereby save money—when load is low.
- [ ] **Use Docker when possible**
      If you deploy everything as an AMI directly on your EC2 Instances, then you will typically run exactly one type of app per EC2 Instance. If you use a Docker orchestration tool (e.g.,  [ECS](https://aws.amazon.com/ecs/)), you can give it a cluster of EC2 Instances to manage, and it will deploy Docker containers across the cluster as efficiently as possible, potentially running multiple apps on the same Instances when resources are available.
- [ ] **Use Lambda when possible**
      For all short (15 min or less) background jobs, cron jobs, ETL jobs, event processing jobs, and other glue code, use  [AWS Lambda](https://aws.amazon.com/lambda/). You not only have no servers to manage, but AWS Lambda pricing is incredibly cheap, with the first 1 million requests and 400,000 GB-seconds per month being completely free! After that, it's just $0.0000002 per request and $0.00001667 for every GB-second.
- [ ] **Clean up old data with S3 Lifecycle settings**
      If you have a lot of data in S3, make sure to take advantage of  [S3 Object Lifecycle Management](https://docs.aws.amazon.com/AmazonS3/latest/dev/object-lifecycle-mgmt.html)  to save money. You can configure the S3 bucket to move files older than a certain age either to cheaper  [storage classes](https://docs.aws.amazon.com/AmazonS3/latest/dev/storage-class-intro.html)  or to delete those files entirely.
- [ ] **Clean up unused resources**
      Use tools such as  [cloud-nuke](https://github.com/gruntwork-io/cloud-nuke)  and  [Janitor Monkey](https://medium.com/netflix-techblog/janitor-monkey-keeping-the-cloud-tidy-and-clean-d517ad74d648)  to clean up unused AWS resources, such as old EC2 Instances or ELBs that no one is using any more. You can run these tools on a regular schedule by using your CI server or  [scheduled lambda functions](https://docs.aws.amazon.com/lambda/latest/dg/with-scheduled-events.html).
- [ ] **Learn to analyze your AWS bill**
      Learn to use tools such as  [Cost and Usage Report](https://docs.aws.amazon.com/awsaccountbilling/latest/aboutv2/billing-reports-costusage.html),  [Cost Explorer](https://aws.amazon.com/aws-cost-management/aws-cost-explorer/),  [Ice](https://github.com/Teevity/ice),  [Trusted Advisor](https://aws.amazon.com/fr/premiumsupport/trustedadvisor/), and  [Cost Optimization Monitor](https://aws.amazon.com/answers/account-management/cost-optimization-monitor/)  to understand where you're spending money. Make sure you understand what each category means (e.g., the delightfully vague "EC2 Other" often means EBS Volumes, AMIs, and Load Balancers). If you find something you can't explain, reach out to AWS Support, and they will help you track it down. Using multiple AWS accounts with  [AWS Organizations](https://aws.amazon.com/organizations/)  and consolidated billing can make it easier to isolate certain types of costs from others (e.g., break down costs by environment or team).
- [ ] **Create billing alarms**
      Create  [billing alerts](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/monitor_estimated_charges_with_cloudwatch.html)  to notify you when your AWS bill crosses important thresholds. Make sure to have several levels of alerts: e.g., at the very least, one when the bill is a little high, one when it's really high, and one when it is approaching bankruptcy levels.
