create database nusqlpocdb ; 

create user nusqlpocuser with encrypted password 'SanJ0s3##' ; 
grant all privileges on database nusqlpocdb to nusqlpocuser  ; 

revoke all privileges on database postgres from nusqlpocuser ;


