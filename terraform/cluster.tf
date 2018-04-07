data "aws_ecs_cluster" "ip_cam_rec" {
  cluster_name = "ip-cam-rec"
}

data "template_file" "container_definitions" {
  template = "${file("container_definitions.j2.json")}"

  vars {
    AWS_ACCESS_KEY_ID     = "${var.AWS_ACCESS_KEY_ID}"
    AWS_SECRET_ACCESS_KEY = "${var.AWS_SECRET_ACCESS_KEY}"
    URL                   = "${var.URL}"
    S3_BUCKET             = "${var.S3_BUCKET}"
  }
}

resource "aws_ecs_task_definition" "ip_cam_rec_task_definition" {
  family                = "ip_cam_rec_task_definition"
  container_definitions = "${data.template_file.container_definitions.rendered}"
}

resource "aws_ecs_service" "ip_cam_rec_service" {
  name            = "ip_cam_rec_service"
  cluster         = "${data.aws_ecs_cluster.ip_cam_rec.id}"
  task_definition = "${aws_ecs_task_definition.ip_cam_rec_task_definition.arn}"
  desired_count   = 1
  launch_type     = "EC2"
}
