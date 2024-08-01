// Originally created with "nf-core modules create varona", then modified

process VARONA {
    tag "$meta.id"
    container "us-central1-docker.pkg.dev/fiery-bit-428319-p1/pohlio-docker/varona:latest"

    input:
    tuple val(meta), path(vcf)

    output:
    tuple val(meta), path("*.csv"), emit: csv
    path "versions.yml", emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"
    """
    varona \\
        --vcf-csv \\
        $args \\
        $vcf \\
        ${prefix}.csv

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        varona: \$(varona --version)
    END_VERSIONS
    """

    stub:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"
    """
    touch ${prefix}.csv

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        varona: \$(varona --version)
    END_VERSIONS
    """
}
