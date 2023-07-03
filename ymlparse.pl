use strict;
use warnings;
use YAML::XS;

# Get the YAML file name and the dot-separated path
my ($file_name, $path) = @ARGV;
die "Usage: perl $0 file_name.yml path.to.value\n" unless defined $file_name && defined $path;

# Read the YAML file
my $yaml_data = YAML::XS::LoadFile($file_name);

# Extract the value based on the provided path
my $value = get_value($yaml_data, $path);
print_value($value);

# Recursive function to get the value from a YAML data structure based on the provided path
sub get_value {
    my ($data, $path) = @_;

    # Split the path into individual keys
    my @keys = split(/\./, $path);

    foreach my $key (@keys) {
        if (ref($data) eq 'HASH') {
            if (exists $data->{$key}) {
                $data = $data->{$key};
            } else {
                return undef;
            }
        } elsif (ref($data) eq 'ARRAY') {
            # Check if the key is an array index
            if ($key =~ /^\d+$/) {
                my $index = int($key);
                if (defined $data->[$index]) {
                    $data = $data->[$index];
                } else {
                    return undef;
                }
            } else {
                return undef;
            }
        } else {
            return undef;
        }
    }

    return $data;
}

# Function to print the value, handling array references
sub print_value {
    my ($value) = @_;

    if (ref($value) eq 'ARRAY') {
        foreach my $element (@$value) {
            print "$element\n";
        }
    } else {
        print "$value\n";
    }
}
