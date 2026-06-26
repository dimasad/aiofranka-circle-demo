"""
Patch aiofranka for MuJoCo 3.x API.
Old: mj_fullM(model, dst, data.qM)
New: mj_fullM(model, data, dst)
"""
import re
import glob

pattern = re.compile(
    r'mj_fullM\(([^,]+),\s*([^,]+),\s*([^)]+)\.qM\)'
)
replacement = r'mj_fullM(\1, \3, \2)'

for path in glob.glob('/tmp/aiofranka/aiofranka/*.py'):
    original = open(path).read()
    patched = pattern.sub(replacement, original)
    if patched != original:
        open(path, 'w').write(patched)
        print(f'Patched {path}')
