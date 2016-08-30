from fabric.api import open_shell
from fabric.api import env
from cloudify import ctx

def set_hostname(hostname):
    ctx.logger.info("Change Cisco CSR1000v's hostname")
    ctx.logger.info(str(env))
    command = "enable \n \
               conf t \n \
               hostname {0} \n \
               end \n \
               write memory \n \
               exit \n".format(hostname)
    open_shell(command)
    return None


