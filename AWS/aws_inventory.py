import boto3
ec2 = boto3.resource('ec2',"us-west-2")

# filter all running instances
instances = ec2.instances.filter(Filters=[{'Name': 'aim*', 'Values': ['running']}])

# Decleared list to store running instances
all_running_instances = []
specific_tag = 'aim-crdb'  
for instance in instances:
    
    # store all running instances
     all_running_instances.append(instance)
        
    # Instances with specific tags
     if instance.tags != None:
         for tags in instance.tags:
             
            # Instances with tag 'env'
             if tags["Key"] == specific_tag:
                
                # Remove instances with specefic tags from all running instances
                 all_running_instances.remove(instance)
                    
#print(all_running_instances)
for specific in all_running_instances:
    print(specific)
    specific.stop()
