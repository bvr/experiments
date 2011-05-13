#!/usr/bin/perl

# from http://www.billruppert.com/2011/04/cachefilecache.html

# tCacheFile.pl - try out Cache::FileCache
# 04/29/2011  Bill Ruppert

use strict;
use warnings;
use Cache::FileCache;

# Setup cache
my $cache = new Cache::FileCache({
	namespace           => 'FruitCache',
	default_expires_in  => '100 days',
	cache_root          => 'C:/tools/cache/',
	auto_purge_interval => '1 day',
});

# Cache some items
$cache->set('Orange', 'A round citrus fruit');
$cache->set('Lemon',  'A yellow pointed sour citrus fruit');
$cache->set('Apple',  'A red roundish fruit good for pies');

# Get all items in cache
print "Get all items in cache:\n";
for ($cache->get_keys()) {
	my $data = $cache->get($_);
	printf "  %-10s: %s\n", $_, $data;
}

# Mix cache hits and misses
print "\nTry some hits and misses:\n";
for (qw( Lemon Kiwi Orange Melon Apple )) {
	my $data = $cache->get($_);
	$data = "Not cached!" unless defined $data;
	printf "  %-10s: %s\n", $_, $data;
}

exit 1;

