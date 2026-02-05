data "aws_instance" "details"{
    instance_id = var.instance_id
}

resource "aws_ec2_instance_state" "stop_instance"{
    instance_id = var.instance_id
    state = "stopped"
}

resource "aws_ebs_snapshot" "take_snap"{
    depends_on = [aws_ec2_instance_state.stop_instance]

    volume_id = tolist(data.aws_instance.details.root_block_device)[0].volume_id

    tags = {
        Name = "snapshot-${var.instance_id}-${timestamp()}"
    }
}

resource "aws_ec2_instance_state" "start_instance"{
    instance_id = var.instance_id
    state = "running"
}
