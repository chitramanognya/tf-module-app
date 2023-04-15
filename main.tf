resource "aws_launch_template" "main" {
  name = "${var.component}-${var.env}"

 // iam_instance_profile {
   // name = "test"
  //}

  image_id = data.aws_ami.ami.id
  instance_market_options {
    market_type = "spot"
  }

  instance_type = var.instance_type

  tag_specifications {
    resource_type = "instance"

    tags = merge(
      var.tags,
      { Name = "${var.component}-${var.env}" }
    
    )
  }



  //user_data = filebase64("${path.module}/example.sh")
}

resource "aws_autoscaling_group" "main" {
  desired_capacity   = var.desired_capacity
  max_size           = var.max_size
  min_size           = var.min_size
  vpc_zone_identifier = var.subnets 
  
  launch_template {
    id      = aws_launch_template.main.id
    version = "$Latest"
  }
}