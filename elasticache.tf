resource "aws_elasticache_subnet_group" "subnet_group" {
  name       = "tf-mlops-subnet-group"
  subnet_ids = "${aws_subnet.private.*.id}"
  
  }
  

resource "aws_elasticache_replication_group" "online_store" {
  replication_group_id       = "tf-online-store"
  description                = "online_store"
  node_type                  = "cache.t2.small"
  port                       = 6379
  parameter_group_name       = "default.redis6.x.cluster.on"
  automatic_failover_enabled = true
  subnet_group_name = aws_elasticache_subnet_group.subnet_group.name

  num_node_groups         = 2
  replicas_per_node_group = 1
}
