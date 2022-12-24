# library to get sha256 hashing algo.
import  hashlib
def hashgenerator(data):
    result=hashlib.sha256(data.encode())
    return result.hexadigit()

# adding hash of block
class Block:
    def __init__(self,data,hash,pre_hash):
        # // block fields

    self.data=data
    self.hash=hash
    self.pre_hash=pre_hash
class Blockchain:
def __init__(self):
    hashlast=hashgenerator('gen_last')
    hashStart=hashgenerator('gen_hash')

    genisis=Block('gen_data',hashStart,hashlast)
    self.chain=[genisis]

    def add_block(self,data):
        prev_hash=self.chain[-1].hash
        hash=hashgenerator(data+prev_hash)
        block=Block(data,hash,prev_hash)
        self.chain.append(block)

        bc=Blockchain()
        bc.add_block('1')
        bc.add_block('2')
        bc.add_block('3')

        for block in bc.chain:
            print(block.__dict__)
