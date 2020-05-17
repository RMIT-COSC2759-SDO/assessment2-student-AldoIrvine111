data "aws_instances" "public" {
  depends_on = [aws_autoscaling_group.todo-app]
  instance_tags = {
    key = "A2 Instance"
  }
}

output "instance_public_ip" {
  value = data.aws_instances.public.public_ips
}

output "lb_endpoint" {
  value = aws_lb.todo_app.dns_name
}

output "db_endpoint" {
  value = aws_db_instance.A2-db.endpoint
}

output "db_user" {
  value = aws_db_instance.A2-db.name
}

output "db_pass" {
  value = aws_db_instance.A2-db.password
}

data "template_file" "inventory" {
  template = "${file("../ansible/templates/inventory.tpl")}"
  depends_on = [
    aws_autoscaling_group.todo-app
  ]
  vars = {
    ec2_ip = element(data.aws_instances.public.public_ips, 0)
  }
}

output "make_inventory" {
  value = data.template_file.inventory.rendered
}

data "template_file" "config_db" {
  template = "${file("../ansible/templates/db-config.tpl")}"
  depends_on = [
    aws_db_instance.A2-db
  ]
  vars = {
    db_host     = aws_db_instance.A2-db.address
    db_name     = aws_db_instance.A2-db.name
    db_username = aws_db_instance.A2-db.username
    db_pass     = aws_db_instance.A2-db.password
  }
}

output "db_update" {
  value = data.template_file.config_db.rendered
}
