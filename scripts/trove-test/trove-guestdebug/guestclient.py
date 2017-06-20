import argparse
from trove.common.remote import create_guest_client
from trove.common.context import TroveContext

def get_context(user, token, tenant_id):
    return TroveContext(user=user,
                        auth_token=token,
                        tenant=tenant_id)

def get_guest(context, guest_id):
     return create_guest_client(context, guest_id)

def guest_prepare(guest, flavor_ram, 
                  packages='', databases=None, users=None,
                  device_path='/dev/sdb',
                  mount_point='/var/lib/mysql',
                  backup_info=None,
                  config_contents=None, root_password=None,
                  overrides=None, cluster_config=None, snapshot=None,
                  modules=None):
    guest.prepare(flavor_ram, packages, databases, users,
                  device_path=volume_info['device_path'],
                  mount_point=volume_info['mount_point'],
                  backup_info=backup_info,
                  config_contents=config_contents,
                  root_password=root_password,
                  overrides=overrides,
                  cluster_config=cluster_config,
                  snapshot=snapshot, modules=modules)

def main():
    parser = argparse.ArgumentParser()
    
if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    
    main()
