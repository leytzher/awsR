

# AWS Utility functions
# Author: Leytzher Muro



def amazonSearchByKeywords(keywords,awsKeyId,awsSecretAccessKey,awsAffiliateId):
    import base64, hashlib, hmac, time
    from urllib import urlencode, quote_plus
    base_url = "http://webservices.amazon.com/onca/xml"
    url_params = dict(
        Service='AWSECommerceService', 
        Operation='ItemSearch', 
        Keywords= keywords,
        SearchIndex='All',
        AWSAccessKeyId=awsKeyId,
        AssociateTag = awsAffiliateId,
        ResponseGroup='Large')
    

    #Can add Version='2009-01-06'. What is it BTW? API version?


    # Add a ISO 8601 compliant timestamp (in GMT)
    url_params['Timestamp'] = time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime())

    # Sort the URL parameters by key
    keys = url_params.keys()
    keys.sort()
    # Get the values in the same order of the sorted keys
    values = map(url_params.get, keys)

    # Reconstruct the URL parameters and encode them
    url_string = urlencode(zip(keys,values))

    #Construct the string to sign
    string_to_sign = "GET\nwebservices.amazon.com\n/onca/xml\n%s" % url_string

    # Sign the request
    signature = hmac.new(
        key=awsSecretAccessKey,
        msg=string_to_sign,
        digestmod=hashlib.sha256).digest()

    # Base64 encode the signature
    signature = base64.encodestring(signature).strip()

    # Make the signature URL safe
    urlencoded_signature = quote_plus(signature)
    url_string += "&Signature=%s" % urlencoded_signature

    #print "%s?%s\n\n%s\n\n%s" % (base_url, url_string, urlencoded_signature, signature)
    print "%s?%s\n" % (base_url, url_string)
    return base_url+"?"+url_string

################


# -*- coding: utf-8 -*-
"""
Created on Thu Apr 30 20:14:09 2015

@author: Leytzher Muro
"""

#import AWS as aws
import csv





# Load AWS details
fname='/Users/user/Documents/asm/key/awsKey.csv'
c = csv.reader(open(fname, "rU"),quotechar='"', delimiter = ',') 
for row in c:    
    AWSAccessKeyId=row[0]
    AWSSecretKey=row[1]
    AWSAffiliateID=row[2]

# Load keywords
kwdFile = '/Users/user/Documents/asm/R/keywords.csv'
kwd = csv.reader(open(kwdFile,"rU"))
for row in kwd:
    keywords=row[0]


# Call Search function and create url
myURL=amazonSearchByKeywords(keywords,AWSAccessKeyId,AWSSecretKey,AWSAffiliateID)
