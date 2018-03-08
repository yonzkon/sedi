#!/usr/bin/env perl

die if ! $ARGV[0];

$template='dn: cn=USERNAME,ou=people,dc=zjrealtech,dc=com
objectclass: person
objectclass: inetOrgPerson
objectclass: top
cn: USERNAME
sn: USERNAME
userPassword: 123456
mail: USERNAME@zjrealtech.com';

$template =~ s/USERNAME/$ARGV[0]/g;
$tmpldif='/tmp/ldap-person.ldif';
$rootdn='cn=Manager,dc=zjrealtech,dc=com';
$rootpw='admin@realtech';

open(TMPFILE, ">$tmpldif");
print TMPFILE "$template";
close(TMPFILE);

print `ldapadd -D $rootdn -w $rootpw -f $tmpldif`;
