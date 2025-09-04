# Ambari Ansible Role

Ansible role for deploying Apache Ambari Server and Agents using either repository or tarball installation methods.

## Requirements

- Ansible 2.9+
- Target hosts running:
  - RHEL/CentOS 7/8
  - Rocky Linux 8/9
  - Ubuntu 18.04/20.04
- SSH access to target hosts
- Internet connectivity for package downloads
- For Ambari 3.0.0: PostgreSQL or MySQL 8.0 database (automatically installed by role)

## Supported Ambari Versions

- **2.7.8** (Stable - use repository method)
- **2.7.9** (Latest 2.x - use repository method)
- **3.0.0** (Latest - use tarball method, default)

## Role Variables

Key variables (see `roles/ambari/defaults/main.yml` for all options):

- `ambari_version`: Ambari version to install (default: 3.0.0)
- `ambari_install_method`: Installation method - "repo" or "tarball" (default: tarball)
- `ambari_repo_base_url`: Repository URL for repo method (default: Apache archive)
- `ambari_tarball_url`: Tarball download URL for tarball method
- `ambari_install_dir`: Installation directory for tarball method (default: /opt/ambari)
- `ambari_build_from_source`: Build from source when using tarball (default: false)
- `ambari_server`: Boolean to install Ambari Server (default: false)
- `ambari_agent`: Boolean to install Ambari Agent (default: true)
- `ambari_server_hostname`: Hostname of Ambari Server
- `ambari_database_type`: Database type (embedded, postgres, mysql, oracle)
- `ambari_admin_user`/`ambari_admin_password`: Admin credentials
- `ambari_stack_name`: Stack to use (HDP, HDF, Bigtop)
- `ambari_stack_version`: Stack version

## Example Playbook

```yaml
---
- name: Deploy Ambari Cluster
  hosts: all
  become: yes
  
  roles:
    - role: ambari
      vars:
        ambari_server: "{{ inventory_hostname in groups['ambari_server'] }}"
        ambari_agent: "{{ inventory_hostname in groups['ambari_agents'] or inventory_hostname in groups['ambari_server'] }}"
```

## Example Inventory

```ini
[ambari_server]
ambari-server.example.com

[ambari_agents]
ambari-agent-[1:3].example.com
```

## Usage

1. Update the inventory file with your hosts
2. Customize variables in `group_vars/all.yml` or `roles/ambari/defaults/main.yml`
3. Run the playbook:

```bash
ansible-playbook -i inventory/hosts.ini site.yml
```

## Repository Configuration

The role uses official Apache Ambari repositories:
- Main repository: https://archive.apache.org/dist/ambari
- Mirror: https://downloads.apache.org/ambari

Repository structure:
- CentOS 7: `ambari/centos7/2.x/updates/<version>/`
- CentOS 8: `ambari/centos8/2.x/updates/<version>/`
- Ubuntu 18.04: `ambari/ubuntu18/2.x/updates/<version>/`
- Ubuntu 20.04: `ambari/ubuntu20/2.x/updates/<version>/`

## Advanced Configuration

### Installation Methods

#### Repository Installation (for Ambari 2.x)
```yaml
ambari_version: "2.7.9"
ambari_install_method: "repo"
ambari_repo_base_url: "https://archive.apache.org/dist/ambari"
```

#### Tarball Installation (for Ambari 3.0.0)
```yaml
ambari_version: "3.0.0"
ambari_install_method: "tarball"
ambari_tarball_url: "https://archive.apache.org/dist/ambari/ambari-3.0.0/apache-ambari-3.0.0-src.tar.gz"
ambari_install_dir: "/opt/ambari"
ambari_build_from_source: false  # Set to true to build from source
```

#### Building from Source
```yaml
ambari_version: "3.0.0"
ambari_install_method: "tarball"
ambari_build_from_source: true
# Requires Maven, GCC, and development tools
```

### Database Configuration

The role automatically installs and configures a database for Ambari 3.0.0.

#### PostgreSQL (Default)
```yaml
ambari_database_type: postgres
ambari_database_install: true  # Install PostgreSQL locally
ambari_database_host: localhost
ambari_database_port: 5432
ambari_database_name: ambari
ambari_database_username: ambari
ambari_database_password: bigdata
ambari_create_service_databases: true  # Create Hive, Ranger, RangerKMS databases
```

#### MySQL 8.0
```yaml
ambari_database_type: mysql
ambari_database_install: true  # Install MySQL locally
ambari_database_host: localhost
ambari_database_port: 3306
ambari_database_name: ambari
ambari_database_username: ambari
ambari_database_password: bigdata
```

#### Using External Database
```yaml
ambari_database_install: false  # Don't install database locally
ambari_database_type: postgres
ambari_database_host: db.example.com
ambari_database_port: 5432
ambari_database_name: ambari
ambari_database_username: ambari_user
ambari_database_password: secure_password
```

The role also creates additional databases for Hadoop services:
- Hive metastore database
- Ranger policy database
- Ranger KMS database

### Enabling SSL

```yaml
ambari_ssl_enabled: true
ambari_two_way_ssl: true
```

### Custom Repository

```yaml
ambari_repo_base_url: "http://your-internal-repo.com/ambari"
```

## Post-Installation

After successful deployment:
1. Access Ambari Web UI at `http://<ambari-server-host>:8080`
2. Default credentials: admin/admin
3. Use the UI to create and manage your Hadoop cluster

## Troubleshooting

- Check Ambari Server logs: `/var/log/ambari-server/`
- Check Ambari Agent logs: `/var/log/ambari-agent/`
- Verify repository access: `yum repolist` or `apt-cache policy ambari-server`
- Test connectivity: `ambari-server status` and `ambari-agent status`

## License

Apache 2.0