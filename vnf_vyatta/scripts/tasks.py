from fabric.api import run,put
from cloudify import ctx

def config(vcli_script):
    ctx.logger.info("Enable netconf service")
    script_file = ctx.download_resource(vcli_script)
    put(script_file, '/tmp/config.vcli')
    run("/tmp/config.vcli")
    return None