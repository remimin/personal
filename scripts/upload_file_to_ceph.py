import rbd
import rados
import math
from os.path import getsize
Mi = 1024 ** 2
chunk_size = 8 * Mi
order = int(math.log(chunk_size, 2))
size = 0  # int(getsize("/tmp/volume-22e86d3c-6528-402a-bacb-872f7ac34a42"))
image_name="0632f527-6ce8-4ac5-81d8-a7a324b843f6"
with rados.Rados(conffile="/etc/ceph/ceph.conf", rados_id="glance") as conn:
    with conn.open_ioctx("images") as ioctx:
        librbd = rbd.RBD()
        if hasattr(rbd, 'RBD_FEATURE_LAYERING'):
            librbd.create(ioctx, image_name, size, order, old_format=False,
                          features=rbd.RBD_FEATURE_LAYERING)
        else:
            librbd.create(ioctx, image_name, size, order, old_format=True)#,features=rbd.RBD_FEATURE_LAYERING)
        offset = 0
        with rbd.Image(ioctx, image_name) as image:
            with open("/tmp/volume-22e86d3c-6528-402a-bacb-872f7ac34a42", 'rb') as fp:
                while True:
                    chunk = fp.read(chunk_size)
                    if chunk != "":
                        length = offset + len(chunk)
                        image.resize(length)
                        offset += image.write(chunk, offset)
                    else:
                        break
