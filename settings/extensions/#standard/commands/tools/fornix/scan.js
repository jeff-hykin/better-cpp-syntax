#!/usr/bin/env -S deno run --allow-all

const { run, Timeout, Env, Cwd, Stdin, Stdout, Stderr, Out, Overwrite, AppendTo, zipInto, mergeInto, returnAsString, } = await import(`https://deno.land/x/quickr@0.3.21/main/run.js`)
const { FileSystem } = await import(`https://deno.land/x/quickr@0.3.21/main/file_system.js`)
const { Console } = await import(`https://deno.land/x/quickr@0.3.21/main/console.js`)


Console.env.NIXPKGS_ALLOW_BROKEN = "1"

// increases resolution over time
function* binaryListOrder(aList, ) {
    const length = aList.length
    const middle = Math.floor(length/2)
    yield aList[middle]
    if (length > 1) {
        const upperItems = binaryListOrder(aList.slice(0,middle))
        const lowerItems = binaryListOrder(aList.slice(middle+1))
        // all the sub-elements
        for (const eachUpper of upperItems) {
            yield eachUpper
            const eachLower = lowerItems.next()
            if (!eachLower.done) {
                yield eachLower.value
            }
        }
    }
}

function getAllPackageInfo(hash) {
    const jsonString = await run`nix-env -qa --json -I https://github.com/NixOS/nixpkgs/archive/${hash}.tar.gz ${Stdout(returnAsString)}`
    return JSON.parse(jsonString)
}

function getPackageJsonFor(packageAttrPath, hash) {
    const jsonString = await run`nix-env -qaA ${packageAttrPath} --json -I https://github.com/NixOS/nixpkgs/archive/${hash}.tar.gz ${Stdout(returnAsString)}`
    return JSON.parse(jsonString)[packageAttrPath]
}

function convertPackageInfo(attrName, packageInfo) {
    const output = {
        name: "",
        description: "",
        versionString: "",
        homepage: "",
        license: "", // full name
        semver: [],
        unfree: false,
        insecure: false,
        broken: false,
        platforms: [],
        attributeName: attrName.split("."),
        sources: [],
    }
    
    if (packageInfo.pname) {
        output.name = packageInfo.pname
    } else if (packageInfo.name && packageInfo.version) {
        output.name = packageInfo.name.slice(0,packageInfo.version.length+1)
    } else if (packageInfo.name) {
        output.name = packageInfo.name.replace(/-.*/, "")
    } else {
        return null
    }
    
    if (packageInfo.version) {
        output.versionString = packageInfo.version
    } else if (packageInfo.name && packageInfo.pname) {
        output.versionString = packageInfo.name.slice(packageInfo.pname+1)
    } else if (packageInfo.name) {
        output.versionString = packageInfo.name.replace(/.+?-/, "")
    } else {
        return null
    }

    const semverMatch = output.versionString.match(/((?:\d+)\.(?:\d+)(?:\.(?:\d+))*)(.+)/)
    if (semverMatch) {
        output.semver = semverMatch[1].split(".").map(each=>each-0)
        const tagIfAny = semverMatch[2]
        if (tagIfAny) {
            output.semver.push(tagIfAny)
        }
    }
    
    
    output.license = packageInfo.license.fullName

    output.shortDescription = packageInfo.meta.description
    output.longDescription  = packageInfo.meta.longDescription
    output.homepage         = packageInfo.meta.homepage
    output.unfree           = packageInfo.meta.unfree
    output.insecure         = packageInfo.meta.insecure
    output.broken           = packageInfo.meta.broken
    output.platforms        = packageInfo.meta.platforms

    return output
    // "nixpkgs.python310": {
    //     "name": "python3-3.10.2",
    //     "pname": "python3",
    //     "version": "3.10.2",
    //     "system": "x86_64-darwin",
    //     "meta": {
        //     "available": true,
        //     "broken": false,
        //     "description": "A high-level dynamically-typed programming language",
        //     "homepage": "http://python.org",
        //     "insecure": false,
        //     "license": {
        //         "deprecated": false,
        //         "free": true,
        //         "fullName": "Python Software Foundation License version 2",
        //         "redistributable": true,
        //         "shortName": "psfl",
        //         "spdxId": "Python-2.0",
        //         "url": "https://spdx.org/licenses/Python-2.0.html"
        //     },
        //     "longDescription": "Python is a remarkably powerful dynamic programming language that\nis used in a wide variety of application domains. Some of its key\ndistinguishing features include: clear, readable syntax; strong\nintrospection capabilities; intuitive object orientation; natural\nexpression of procedural code; full modularity, supporting\nhierarchical packages; exception-based error handling; and very\nhigh level dynamic data types.\n",
        //     "maintainers": [
        //         {
        //         "email": "fridh@fridh.nl",
        //         "github": "fridh",
        //         "githubId": 2129135,
        //         "name": "Frederik Rietdijk"
        //         }
        //     ],
        //     "name": "python3-3.10.2",
        //     "outputsToInstall": [
        //         "out"
        //     ],
        //     "platforms": [
        //         "aarch64-linux",
        //         "armv5tel-linux",
        //         "armv6l-linux",
        //         "armv7a-linux",
        //         "armv7l-linux",
        //         "i686-linux",
        //         "m68k-linux",
        //         "mipsel-linux",
        //         "powerpc64-linux",
        //         "powerpc64le-linux",
        //         "riscv32-linux",
        //         "riscv64-linux",
        //         "s390-linux",
        //         "s390x-linux",
        //         "x86_64-linux",
        //         "x86_64-darwin",
        //         "i686-darwin",
        //         "aarch64-darwin",
        //         "armv7a-darwin"
        //     ],
        //     "position": "/nix/store/wkbdshg9bqx62x1pjpmhk6kb9pfrymcw-nixpkgs-22.05pre360843.3eb07eeafb5/nixpkgs/pkgs/development/interpreters/python/cpython/default.nix:494",
        //     "unfree": false,
        //     "unsupported": false
    //     }
    // }
}

const hashJsonPrimitive = (value) => JSON.stringify(value).split("").reduce(
    (hashCode, currentVal) => (hashCode = currentVal.charCodeAt(0) + (hashCode << 6) + (hashCode << 16) - hashCode),
    0
)

const allPackages = {}
async function asyncAddPackageInfo(packageInfo, commitHash) {
    packageInfoCopy = {...packageInfo}
    packageInfoCopy.sources = []
    const hashValue = hashJsonPrimitive(packageInfoCopy)
    // import data based on hash
    const filePath = `./packages/${packageInfo.name}/${hashValue}.json`
    const info = await FileSystem.info(filePath)
    if (info.isFile) {
        try {
            packageInfo = JSON.stringify(await FileSystem.read(filePath))
        } catch (error) {
            console.warn(error)
        }
    }
    
    // create package if doesn't exist
    if (!(packageInfo.name in allPackages)) {
        allPackages[packageInfo.name] = {}
    }
    
    // create hash if needed
    allPackages[packageInfo.name][hashValue] = packageInfo
    // add source
    allPackages[packageInfo.name][hashValue].sources.push(`https://github.com/NixOS/nixpkgs/tree/${commitHash}`)

    await FileSystem.write({
        path: filePath,
        data: JSON.stringify(allPackages[packageInfo.name][hashValue]),
    })
}

function listAllCommitHashes() {
    const stringOutput = await run`git log --first-parent --date=short --pretty=format:%H ${Stdout(returnAsString)}`
    return stringOutput.split("\n")
}




// 
// main algo
// 
const concurrentSize = 30
for (const commitHash of binaryListOrder(listAllCommitHashes())) {
    try {
        const allPackages = getAllPackageInfo(commitHash)
        const waitingGroup = []
        for (const [attrName, packageInfo] of Object.entries(allPackages)) {
            waitingGroup.push(asyncAddPackageInfo(packageInfo, commitHash))
            if (waitingGroup.length > concurrentSize) {
                await Promise.allSettled(waitingGroup)
                waitingGroup = []
            }
        }
    } catch (error) {
        console.warn(`on commit: ${commitHash}, `, error)
    }
}