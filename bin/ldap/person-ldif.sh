#!/bin/sh

[ -z "$1" ] && echo "do nothing..." && exit 1

template='echo -e
"dn: cn=$USERNAME,ou=people,dc=zjrealtech,dc=com\n"
"objectclass: person\n"
"objectclass: inetOrgPerson\n"
"objectclass: top\n"
"cn: $USERNAME\n"
"sn: $USERNAME\n"
"userPassword: 123456\n"
"mail: $USERNAME@zjrealtech.com\n"'

USERNAME=$1
TMPFILE='/tmp/ldap-person.ldif'

ROOTDN='cn=Manager,dc=zjrealtech,dc=com'
ROOTPW='admin@realtech'
eval $template | cat > $TMPFILE
ldapadd -D $ROOTDN -w $ROOTPW -f $TMPFILE
