#sudo apt install python3 python-is-python3 python3-pycryptodome
import base64
from cryptography.hazmat.primitives import hashes
from cryptography.hazmat.primitives.asymmetric import padding
from cryptography.hazmat.primitives.serialization import pkcs12
import sys


class TokenGenerator:
    def __init__(self, certificate_path, certificate_password, merchant_id, acq_id, merchant_categ, txn_currency, txn_amount, bill_id, user_id):
        self.certificate_path = certificate_path
        self.certificate_password = certificate_password
        self.merchant_id = merchant_id
        self.acquirer_id = acq_id
        self.merchant_categ = merchant_categ
        self.txn_currency = txn_currency
        self.txn_amount = txn_amount
        self.bill_id = bill_id
        self.user_id = user_id
        self.private_key = None
        self._load_private_key()

    def _load_private_key(self):
        try:

            with open(self.certificate_path, "rb") as cert_file:
                pfx_data = cert_file.read()
                self.private_key, _, _ = pkcs12.load_key_and_certificates(
                    pfx_data, self.certificate_password.encode("utf-8")
                )
                if not self.private_key:
                    raise Exception("No private key found in the certificate.")
        except Exception as e:
            raise Exception(f"Error loading .pfx file: {str(e)}")

    def generate_token(self, custom_string=None):

        if not custom_string:
            custom_string = (
                f"{self.acquirer_id},{self.merchant_id},{self.merchant_categ},"
                f"{self.txn_currency},{self.txn_amount},{self.bill_id},{self.user_id}"
            )
        return custom_string

    def sign_token(self, token_string):
        try:

            signature = self.private_key.sign(
                token_string.encode("utf-8"),
                padding.PKCS1v15(),
                hashes.SHA256()
            )

            return base64.b64encode(signature).decode("utf-8")
        except Exception as e:
            raise Exception(f"Unable to sign token: {str(e)}")


# Example
if __name__ == "__main__":
    arr = sys.argv[1].split(',')  
    
    token_generator = TokenGenerator(
        certificate_path=arr[7],
        certificate_password=arr[8],
        merchant_id=arr[1],
        acq_id=arr[0],
        merchant_categ=arr[2],
        txn_currency=arr[3],
        txn_amount=arr[4],
        bill_id=arr[5],
        user_id=arr[6]
    )


    token_string = token_generator.generate_token()


    signature = token_generator.sign_token(token_string)

    # print("Token String:", token_string)
    print("Base64-encoded Signature:", signature)

