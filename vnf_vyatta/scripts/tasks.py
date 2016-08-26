from fabric.api import run,put
from cloudify import ctx

def config(vcli_script):
    ctx.logger.info("Enable netconf service")
    script_file = ctx.download_resource(vcli_script)
    put(script_file, '/tmp/config.vcli')
    run("/tmp/config.vcli")
    return None
    
def set_hostname(hostname):
    ctx.logger.info("Change vRouter 5600's hostname")
    run("configure;\
        set system host-name {0};\
        commit;\
        save;\
        end_configure;".format(hostname))
    return None
    
def set_nat(network_cidr):
    ctx.logger.info("Set Source NAT for network {0}".format(network_cidr))
    config = "configure;\
        set service nat source rule 1;\
        set service nat source rule 1 source address {0};\
        set service nat source rule 1 outbound-interface dp0s3;\
        set service nat source rule 1 translation address masquerade;\
        commit;\
        save;\
        end_configure;".format(network_cidr)
    ctx.logger.info(config)
    run(config)
    return None